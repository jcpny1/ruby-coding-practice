class BoatScraper
  # .BoatScraper converts Boattrader.com power boat classified listings into objects

  # Creates listings from summary web page
  def self.scrape_results_page(url, url_file, doc, item_class)
    # doc.css('.aiResultsWrapper').each { |result|
    #   id = self.get_listing_id(result)
    #
    #   title = get_title(result)
    #   title_parts = split_title(title)  # => [year, make, model]
    #
    #   description_pod_div = result.css('.aiDescriptionPod')
    #   start_date = get_date(description_pod_div)
    #   mileage = get_mileage(description_pod_div)
    #   price = get_price(description_pod_div)
    #
    #   detail_url = get_detail_url(url, result)
    #   condition = get_condition(detail_url)
    #   contact_div = result.css('.contactLinks')
    #   seller_name = get_seller_name(contact_div)
    #   seller_location = get_seller_location(contact_div)
    #   seller_phone = get_seller_phone(contact_div, id, url_file)
    #
    #   item = item_class.new(title_parts[0], title_parts[1], title_parts[2], mileage, price, condition, detail_url)
    #   seller = Seller.find_or_create(seller_name, seller_location, seller_phone)
    #   Listing.new(id, item, seller, start_date)
    # }
  end

  # Returns detail attributes and values in detail_values hash
  def self.scrape_results_detail_page(detail_url, condition, detail_values)
    # detail_doc = Nokogiri::HTML(open(detail_url, :read_timeout=>10))
    # # Create some entries manually.
    # detail_values['Description'.to_sym] = detail_doc.css('.aiDetailsDescription')[0].children[2].text.strip
    # detail_values['Condition'.to_sym] = condition
    # detail_values['Certified'.to_sym] = ''
    # # Create the rest from scraping the html's detail attrribute/value table.
    # detail_cells = get_detail_cells(detail_doc)
    # index = 0
    # while index < detail_cells.size
    #   if "\u00A0" == detail_cells[index].text  && 'aiCPOiconDetail' == detail_cells[index].children[0].attributes['class'].content
    #     detail_values[:Certified] = 'Yes' # The Certified icon attribute does not have a value.
    #     index += 1
    #   else  # Grab the attribute and value from the html table.
    #     attribute = detail_cells[index].text.chomp(':')
    #     value = detail_cells[index+1].text
    #     detail_values[attribute.to_sym] = value
    #     index += 2
    #   end
    # end
  end

## PRIVATE METHODS
private

end
