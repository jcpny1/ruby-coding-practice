class BoatScraper
  # .BoatScraper converts Boattrader.com power boat classified listings into objects

  # Creates listings from summary web page
  def self.scrape_results_page(url, url_file, doc, item_class)
    doc.css('.boat-listings li').each { |result|
      id = get_listing_id(result)

      if id == nil
        next
      end

      descr_div = result.css('.description')
      title = get_title(descr_div)
      title_parts = split_title(title)  # => [year, make, model]
      price = get_price(descr_div)
      seller_location = get_seller_location(descr_div)
      seller_name = get_seller_name(descr_div)


      # condition = get_condition(detail_url)
      # contact_div = result.css('.contactLinks')
      # seller_name = get_seller_name(contact_div)
      # seller_location = get_seller_location(contact_div)
      # seller_phone = get_seller_phone(contact_div, id, url_file)

      detail_url = get_detail_url(url, result)
  condition = 'Used' # FIX ME # condition = get_condition(detail_url)

      item = item_class.new(title_parts[0], title_parts[1], title_parts[2], price, condition, detail_url)
  #   item = item_class.new(title_parts[0], title_parts[1], title_parts[2], mileage, price, condition, detail_url)

      seller = Seller.find_or_create(seller_name, seller_location, '')
  #   seller = Seller.find_or_create(seller_name, seller_location, seller_phone)

      Listing.new(id, item, seller, '')
  #   Listing.new(id, item, seller, start_date)

#   seller_phone = get_seller_phone(contact_div, id, url_file)   // FROM DETAIL PAGE .dealer_info .name .contact text
#   mileage = get_mileage(description_pod_div)  // HOURS from detail page
#   description_pod_div = result.css('.aiDescriptionPod')  // from detail page


    #   start_date = get_date(description_pod_div)

    #
    #   condition = get_condition(detail_url)
    #   contact_div = result.css('.contactLinks')
    #
    }
  end

  # Returns detail attributes and values in detail_values hash
  def self.scrape_results_detail_page(detail_url, condition, detail_values)
    detail_doc = Nokogiri::HTML(open(detail_url, :read_timeout=>10))
    boat_details = detail_doc.css('.boat-details')

    if 0 == boat_details.size
      do_alt_processing(detail_doc, condition, detail_values)
      return
    end

    # Create some entries manually.
    detail_values['Description'.to_sym] = detail_doc.css('#main-details').text.strip
    detail_values['Condition'.to_sym] = condition
#    detail_values['Certified'.to_sym] = ''

    # Create the rest from scraping the html's detail attrribute/value table.
    detail_cells = get_detail_cells(boat_details)
    index = 0
    while index < detail_cells.size
    #   if "\u00A0" == detail_cells[index].text  && 'aiCPOiconDetail' == detail_cells[index].children[0].attributes['class'].content
    #     detail_values[:Certified] = 'Yes' # The Certified icon attribute does not have a value.
    #     index += 1
    #   else  # Grab the attribute and value from the html table.
      attribute_tag = detail_cells[index].children[1]
      if (attribute_tag != nil)
        attribute = attribute_tag.text
        value_tag = detail_cells[index].children[3]

        if (value_tag == nil)  # look for dt
          dl_tag = detail_cells[index].css('dl').children
          child = 0
          while child < dl_tag.size
            attribute = dl_tag[child+1]
            if attribute != nil
              attribute = dl_tag[child+1].text
              value_tag = dl_tag[child+3]
              detail_values[attribute.to_sym] = value_tag.text if value_tag != nil
            end
            child += 4
          end
        else
          if attribute == 'Owner Video' && value_tag != nil
            value = 'Yes'
          else
            value = value_tag.text
          end
          detail_values[attribute.to_sym] = value if value_tag != nil
        end
      end  # while index < detail_cells.size
      index += 1
    end

    detail_values['Phone'.to_sym] = detail_doc.css('.phone').text
  end

## PRIVATE METHODS
private


def self.do_alt_processing(doc, condition, detail_values)
  # Create some entries manually.
  main_content = doc.css('#main-content')
  detail_values['Description'.to_sym] = main_content.css('p').text.strip
  detail_values['Condition'.to_sym] = condition

  detail_cells = main_content.css('#ad_detail-table tr')

  index = 0
  while index < detail_cells.size
    dl_tag = detail_cells[index].children
    child = 0
    while child < dl_tag.size
      attribute = dl_tag[child].text
      value     = dl_tag[child+1].text
      detail_values[attribute.to_sym] = value
      child += 2
    end
    index += 1
  end

  # NOTE: keep phone number last in list for display consistency
  phone = main_content.css('.seller-info .phone').text
  phone.reverse!  # alt listing phone has css format 'direction: rtl'
  phone[0] = '('; phone[4] = ')'
  detail_values['Phone'.to_sym] = phone
end

# Returns the detail table
def self.get_detail_cells(doc)
  doc.css('#collapsible-content-areas tr')
end

# Returns a summary record's detail page url
def self.get_detail_url(url, doc)  # detail link is given as relative to the summary page's domain
  uri = URI.parse(url)
  "#{uri.scheme}://#{uri.host}#{doc.css('.inner a')[0]['href']}"
end

  # Returns the listing's id. If the listing doesn't have an id, it's not really a listing.
  def self.get_listing_id(doc)
    value = doc.attributes['data-reporting-impression-product-id']
    value.text if value != nil
  end

  # Returns the listing's sale price
  def self.get_price(doc)
    value = doc.css('.price .data').text
    value != '' ? value : doc.css('.price .txt')[0].children[1].text
  end

  # Returns the listing's sale price
  def self.get_seller_location(doc)
    value = doc.css('.location .data').text
    value != '' ? value : doc.css('.location .txt')[0].children[1].text
  end

  # Returns the seller's name
  def self.get_seller_name(doc)
    value = doc.css('.offered-by .data').text
    value != '' ? value : doc.css('.offered-by .txt')[0].children[1].text
  end

  # Returns the summary listing's title
  def self.get_title(doc)
    doc.css('.name').text  # '2000 JASON 25 Downeaster' (also Grady White, Grady-White, Sea Ray, ...)
  end

  # Returns the year, make, and model from the title string
  # NOTE: It is assumed that make will be one word. Otherwise, likely need database of make names to match against.
  def self.split_title(title)
    title_parts = title.split(' ')
    year = title_parts[0]  # year
    make = title_parts[1]  # make
    model = title_parts.last(title_parts.size - 2).join(' ')  # model
    [year, make, model]
  end
end
