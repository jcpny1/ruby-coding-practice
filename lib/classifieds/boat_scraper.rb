class Classifieds::BoatScraper  # converts Boattrader.com power boat classified listings into objects
  # Currently coded for BoatTrader.com only

  private_class_method :new

  # Creates listings from summary web page
  def self.scrape_results_page(results_url, results_url_file, results_doc, item_class)
    results_doc.css('.boat-listings li').each { |result|
      id = listing_id(result)
      next if id.nil?

      descr_div = result.css('.description')
      title_parts = split_title(descr_div)  # => [year, make, model]
      start_date = ''  # Listing start_date currently not available from web page.
      sale_price = sale_price(descr_div)
      seller_name = seller_name(descr_div)
      seller_location = seller_location(descr_div)
      seller_phone = ''  # Seller phone currently not available from web page.

      detail_url = detail_url(results_url, result)
      item_condition = 'Used'  # Condition currently not available from web page.

      item = item_class.new(title_parts[0], title_parts[1], title_parts[2], sale_price, item_condition, detail_url)
      seller = Classifieds::Seller.find_or_create(seller_name, seller_location, seller_phone)
      Classifieds::Listing.new(id, item, seller, start_date)
    }
  end

  # Returns detail attributes and values in detail_values hash
  def self.scrape_results_detail_page(detail_doc, item_condition, detail_values)
    boat_details_doc = detail_doc.css('.boat-details')

    if boat_details_doc.empty?
      do_alt_processing(detail_doc, item_condition, detail_values)
    else
      do_normal_processing(detail_doc, boat_details_doc, item_condition, detail_values)
    end
  end

## PRIVATE METHODS
private

  # Returns the detail table
  def self.detail_cells(doc)
    doc.css('#collapsible-content-areas tr')
  end

  # Returns the detail table
  def self.detail_cells_alt(doc)
    doc.css('#ad_detail-table tr')
  end

  # Returns a summary record's detail page url
  def self.detail_url(url, doc)  # detail link is given as relative to the summary page's domain
    uri = URI.parse(url)
    "#{uri.scheme}://#{uri.host}#{doc.css('.inner a')[0]['href']}"
  end

  # Returns detail attributes and values in detail_values hash
  def self.do_alt_processing(doc, item_condition, detail_values)
    # Create some entries manually.
    main_content = doc.css('#main-content')
    detail_values['Description'.to_sym] = main_content.css('p').text.strip
    detail_values['Condition'.to_sym] = item_condition

    # Create the rest from scraping the html's detail attrribute/value table.
    detail_cells = detail_cells_alt(main_content)
    (0...detail_cells.size).each { |index|
      dl_tag = detail_cells[index].children
      (0...dl_tag.size).step(2) { |child|
        attribute = dl_tag[child].text
        value = dl_tag[child+1].text
        detail_values[attribute.to_sym] = value
      }
    }

    detail_values['Phone'.to_sym] = seller_phone(main_content)  # NOTE: keep phone number last in list for display consistency.
  end

  # Returns detail attributes and values in detail_values hash
  def self.do_normal_processing(doc, boat_doc, item_condition, detail_values)
    # Create some entries manually.
    detail_values['Description'.to_sym] = doc.css('#main-details').text.strip
    detail_values['Condition'.to_sym] = item_condition

    # Create the rest from scraping the html's detail attrribute/value table.
    detail_cells = detail_cells(boat_doc)
    (0...detail_cells.size).each { |index|
      attribute_tag = detail_cells[index].children[1]

      if attribute_tag
        dl_tag = attribute_tag.css('dl')

        if 0 < dl_tag.size  # need to do alternate normal processing.
          process_detail_list_alt(dl_tag, detail_values)
        else
          attribute = attribute_tag.text
          value_tag = detail_cells[index].children[3]

          if value_tag
            text_value = (attribute == 'Owner Video' ? 'Yes' : value_tag.text)  # substitute Yes for the video link.
            detail_values[attribute.to_sym] = text_value
          else
            process_detail_list(detail_cells[index].css('dl').children, detail_values)
          end
        end
      end
    }

    detail_values['Phone'.to_sym] = doc.css('.phone').text  # NOTE: keep phone number last in list for display consistency.
  end

  # Returns the listing's id. If the listing doesn't have an id, it's not really a listing.
  def self.listing_id(doc)
    value = doc.attributes['data-reporting-impression-product-id']
    value.text if value
  end

  # Parse description list data into hash
  def self.process_detail_list(doc, detail_values)
    (0...doc.size).step(4) { |index|
      attribute = doc[index+1]
      next if attribute.nil?
      attr_text = attribute.text
      value_tag = doc[index+3]
      detail_values[attr_text.to_sym] = value_tag.text if value_tag
    }
  end

  # Parse description list data into hash
  def self.process_detail_list_alt(doc, detail_values)
    (0...doc.size).each { |index|
      children = doc[index].children
      child_index = 1
      while child_index < children.size
        attribute = children[child_index].text
        value = children[child_index+2]
        if value.nil? || value.text.strip.size == 0
          value = children[child_index+1]
          child_index += 3
        else
          child_index += 4
        end
        detail_values[attribute.to_sym] = value.text.sub('&check;', 'Y') if value
      end
    }
  end

  # Returns the listing's sale price
  def self.sale_price(doc)
    value = doc.css('.price .data').text
    value != '' ? value : doc.css('.price .txt')[0].children[1].text
  end

  # Returns the seller's address
  def self.seller_location(doc)
    value = doc.css('.location .data').text
    value != '' ? value : doc.css('.location .txt')[0].children[1].text
  end

  # Returns the seller's name
  def self.seller_name(doc)
    value = doc.css('.offered-by .data').text
    value != '' ? value : doc.css('.offered-by .txt')[0].children[1].text
  end

  # Returns the Seller's phone number
  def self.seller_phone(doc)
    phone = doc.css('.seller-info .phone').text
    phone.reverse!  # alt listing phone has css format 'direction: rtl'
    phone[0] = '('; phone[4] = ')'
    phone
  end

    # Returns the year, make, and model from the title string
    # NOTE: It is assumed that Make will be one word.
    #       Otherwise, likely will need a database of Make names to match against.
    def self.split_title(doc)
      title_parts = title(doc).split(' ')
      year = title_parts[0]  # year
      make = title_parts[1]  # make
      model = title_parts.last(title_parts.size - 2).join(' ')  # model
      [year, make, model]
    end

  # Returns the summary listing's title
  def self.title(doc)
    doc.css('.name').text  # '2000 JASON 25 Downeaster' (also Grady White, Grady-White, Sea Ray, ...)
  end
end
