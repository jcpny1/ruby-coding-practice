class AutoScraper
  # .AutoScraper converts Newsday automobile classified listings into objects

  # Creates listings from summary web page
  def self.scrape_results_page(url, url_file, doc, item_class)
    doc.css('.aiResultsWrapper').each { |result|
      id = get_listing_id(result)

      title = get_title(result)
      title_parts = split_title(title)  # => [year, make, model]

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
  def self.scrape_results_detail_page(detail_url, condition, detail_values)
    detail_doc = Nokogiri::HTML(open(detail_url, :read_timeout=>10))
    # Create some entries manually.
    detail_values['Description'.to_sym] = detail_doc.css('.aiDetailsDescription')[0].children[2].text.strip
    detail_values['Condition'.to_sym] = condition
    detail_values['Certified'.to_sym] = ''
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

## PRIVATE METHODS
private

  # Returns the item condition, as encoded in the detail page url
  def self.get_condition(url)
    url.match(/[a-z0-9]-(certified|new|used)-[0-9]/)[1].capitalize
  end

  # Returns listing start date
  def self.get_date(doc)
    doc.css('.listingDate').text
  end

  # Returns the detail table
  def self.get_detail_cells(doc)
    doc.css('.aiDetailAdDetails td')
  end

  # Returns a summary record's detail page url
  def self.get_detail_url(url, doc)  # detail link is given as relative to the summary page's domain
    uri = URI.parse(url)
    "#{uri.scheme}://#{uri.host}#{doc.css('.aiResultTitle h3 a')[0]['href']}"
  end

  # Returns the listing's id
  def self.get_listing_id(doc)  # e.g. from "aiResultsMainDiv547967889"
    doc.css('.aiResultsMainDiv')[0]['id'].match(/\d+/).to_s
  end

  # Returns the listing's mileage value
  def self.get_mileage(doc)
    value = doc.css('.listingType').text  # e.g. 'Mileage: xx,xxx'
    (value.include? 'Available') ? 'NA' : value.match(/Mileage: (\d*,{,1}\d+)/)[1]
  end

  # Returns the listing's sale price
  def self.get_price(doc)
    value = doc.css('.price').text
    (value.include? 'Call') ? 'Call' : value
  end

  # Returns the seller's location
  def self.get_seller_location(doc)
    doc.css('strong')[1].text.strip
  end

  # Returns the seller's name
  def self.get_seller_name(doc)
    doc.css('strong')[0].text.strip
  end

  PHONE_PATTERN = '\(\d\d\d\) \d\d\d-\d\d\d\d'

  # Returns the seller's phone number, if it exists
  def self.get_seller_phone(doc, id, url_file)
    span = doc.css('span')
    match_data = span[0].text.match(/#{PHONE_PATTERN}/) if 1 < span.size
    match_data != nil ? match_data[0] : get_seller_phone_private(url_file, id)
  end

  # Returns the seller's phone number, if found in the raw HTML text
  def self.get_seller_phone_private(url_file, id)
    match_data = nil
    open(url_file).detect { |line| match_data = line.match(/#{PHONE_PATTERN}/) if line.include? ('aiGetPhoneNumber'+id) }
    match_data != nil ? match_data[0] : ''
  end

  # Returns the summary listing's title
  def self.get_title(doc)
    doc.css('.aiResultTitle h3').text  # '2010 Ford Explorer XL'
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
