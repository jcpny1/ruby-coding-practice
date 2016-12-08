class Scraper
  # .Scraper converts a Newsday classified advertisement results web page into objects

  # Creates listings from scraped summary web page
  def self.create_listings(url, item_class)
    url_file = open(url, :read_timeout=>10)
    doc = Nokogiri::HTML(url_file)
    case item_class.class
    when Automobile.class
      scrape_automobile_results_page(url, url_file, doc, item_class)
    else
      puts "Unsupported item type"
    end
  end

  # Returns detail attributes and values in detail_values hash
  def self.get_listing_details(item_class, detail_url, listing_id, condition, phone, detail_values)
    case item_class.class
    when Automobile.class
      scrape_automobile_results_detail_page(detail_url, listing_id, condition, phone, detail_values)
    else
      puts "Unsupported item type"
    end
  end

## PRIVATE METHODS
private

  # Returns the item condition, as encoded in the detail page url
  def self.get_condition(detail_url)
    detail_url.match(/[a-z0-9]-(certified|new|used)-[0-9]/)[1].capitalize
  end

  # Returns listing start date
  def self.get_date(description)
    description.css('.listingDate').text
  end

  # Returns the detail table
  def self.get_detail_cells(detail_doc)
    detail_doc.css('.aiDetailAdDetails td')
  end

  # Returns a summary record's detail page url
  def self.get_detail_url(url, auto_result)  # detail link is given as relative to summary page's domain
    uri = URI.parse(url)
    "#{uri.scheme}://#{uri.host}#{auto_result.css('.aiResultTitle h3 a')[0]['href']}"
  end

  # Returns the listing's id
  def self.get_listing_id(auto_result)  # e.g. from "aiResultsMainDiv547967889"
    auto_result.css('.aiResultsMainDiv')[0]['id'].match(/\d+/).to_s
  end

  # Returns the listing's mileage value
  def self.get_mileage(description)
    mileage_text = description.css('.listingType').text  # e.g. 'Mileage: xx,xxx'
    (mileage_text.include? 'Available') ? 'NA' : mileage_text.match(/Mileage: (\d*,{,1}\d+)/)[1]
  end

  # Returns the listing's sale price
  def self.get_price(description)
    price_text = description.css('.price').text
    (price_text.include? 'Call') ? 'Call' : price_text
  end

  # Returns the seller's location
  def self.get_seller_location(contact)
    contact.css('strong')[1].text.strip
  end

  # Returns the seller's name
  def self.get_seller_name(contact)
    contact.css('strong')[0].text.strip
  end

  PHONE_PATTERN = '\(\d\d\d\) \d\d\d-\d\d\d\d'

  # Returns the seller's phone number, if it exists
  def self.get_seller_phone(contact, id, url_file)
    span = contact.css('span')
    match_data = span[0].text.match(/#{PHONE_PATTERN}/) if span.size > 1
    match_data != nil ? match_data[0] : get_seller_phone_private(url_file, id)
  end

  # Returns the seller's phone number, if found in the raw HTML text
  def self.get_seller_phone_private(url_file, id)
    match_data = nil
    open(url_file).detect { |line| match_data = line.match(/#{PHONE_PATTERN}/) if line.include? ('aiGetPhoneNumber'+id) }
    match_data != nil ? match_data[0] : ''
  end

  # Returns the summary listing's title
  def self.get_title(auto_result)
    auto_result.css('.aiResultTitle h3').text  # '2010 Ford Explorer XL'
  end

  # Creates listings from scraped summary web page
  def self.scrape_automobile_results_page(url, url_file, doc, item_class)
    doc.css('.aiResultsWrapper').each { |result|
      id = self.get_listing_id(result)

      title = get_title(result)
      title_parts = split_title(title)  # [year, make, model]

      description_pod_div = result.css('.aiDescriptionPod')
      start_date = get_date(description_pod_div)
      mileage = get_mileage(description_pod_div)
      price = get_price(description_pod_div)

      detail_url = get_detail_url(url, result)
      condition = get_condition(detail_url)
      contact_div = result.css('.contactLinks')
      seller_name = get_seller_name(contact_div)
      seller_location = get_seller_location(contact_div)
      seller_phone = get_seller_phone(contact_div, id, url_file)

      item = item_class.new(title_parts[0], title_parts[1], title_parts[2], mileage, price, condition, detail_url)
      seller = Seller.find_or_create(seller_name, seller_location, seller_phone)
      Listing.new(id, item, seller, start_date)
    }
  end

  # Returns detail attributes and values in detail_values hash
  def self.scrape_automobile_results_detail_page(detail_url, listing_id, condition, phone, detail_values)
    detail_doc = Nokogiri::HTML(open(detail_url, :read_timeout=>10))
    # Create some entries manually.
    detail_values['Description'.to_sym] = detail_doc.css('.aiDetailsDescription')[0].children[2].text.strip
    detail_values['Listing #'.to_sym] = listing_id
    detail_values['Condition'.to_sym] = condition
    detail_values['Certified'.to_sym] = ''
    detail_values['Phone'.to_sym    ] = phone
    # Create the rest from scraping the html's detail attrribute/value table.
    detail_cells = get_detail_cells(detail_doc)
    index = 0
    while index < detail_cells.size
      if "\u00A0" == detail_cells[index].text  && 'aiCPOiconDetail' == detail_cells[index].children[0].attributes['class'].content
        detail_values[:Certified] = 'Yes' # The Certified icon attribute does not have a value.
        index += 1
      else  # Grab the attribute and value from the html table.
        attribute = detail_cells[index].text.chomp(':')
        value = detail_cells[index+1].text
        detail_values[attribute.to_sym] = value
        index += 2
      end
    end
  end

  # Returns the year, make, and model from the title string
  def self.split_title(title)
    title_parts = title.split(' ')
    year = title_parts[0]
    make = title_parts[1]
    model = title_parts.last(title_parts.size - 2).join(' ')
    [year, make, model]
  end
end
