class Classifieds::AutoScraper  # converts automobile classified listings into objects
  # Currently coded for Newsday.com only

  private_class_method :new

  # Creates listings from summary web page
  def self.scrape_results_page(results_url, results_url_file, results_doc, item_class)
    results_doc.css('.aiResultsWrapper').each { |result|
      id = listing_id(result)
      title_parts = title_parts(result)  # => [year, make, model]

      description_pod_div = result.css('.aiDescriptionPod')
      start_date = start_date(description_pod_div)
      mileage = mileage(description_pod_div)
      sale_price = sale_price(description_pod_div)

      contact_div = result.css('.contactLinks')
      seller_name = seller_name(contact_div)
      seller_location = seller_location(contact_div)
      seller_phone = seller_phone(contact_div, id, results_url_file)

      detail_url = detail_url(results_url, result)
      item_condition = item_condition(detail_url)

      item = item_class.new(title_parts[0], title_parts[1], title_parts[2], mileage, sale_price, item_condition, detail_url)
      seller = Classifieds::Seller.find_or_create(seller_name, seller_location, seller_phone)
      Classifieds::Listing.new(id, item, seller, start_date)
    }
  end

  # Returns detail attributes and values in detail_values hash
  def self.scrape_results_detail_page(detail_doc, item_condition, detail_values)
    # Create some entries manually.
    detail_values['Description'.to_sym] = detail_doc.css('.aiDetailsDescription')[0].children[2].text.strip  # Description must be first attribute.
    detail_values['Condition'.to_sym] = item_condition
    detail_values['Certified'.to_sym] = ''
    # Create the rest from scraping the html's detail attrribute/value table.
    detail_cells = detail_cells(detail_doc)
    index = 0
    while index < detail_cells.size
      if ("\u00A0" == detail_cells[index].text)  && ('aiCPOiconDetail' == detail_cells[index].children[0].attributes['class'].content)
        detail_values[:Certified] = 'Yes' # The table row containing attribute Certified Icon does not have a value column.
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
  def self.item_condition(url)
    url.match(/[a-z0-9]-(certified|new|used)-[0-9]/)[1].capitalize
  end

  # Returns the detail table
  def self.detail_cells(doc)
    doc.css('.aiDetailAdDetails td')
  end

  # Returns a summary record's detail page url
  def self.detail_url(url, doc)  # detail link is given as relative to the summary page's domain
    uri = URI.parse(url)
    "#{uri.scheme}://#{uri.host}#{doc.css('.aiResultTitle h3 a')[0]['href']}"
  end

  # Returns the listing's id
  def self.listing_id(doc)  # e.g. from "aiResultsMainDiv547967889"
    doc.css('.aiResultsMainDiv')[0]['id'].match(/\d+/).to_s
  end

  # Returns the listing's mileage value
  def self.mileage(doc)
    value = doc.css('.listingType').text  # e.g. 'Mileage: xx,xxx'
    (value.include? 'Available') ? 'NA' : value.match(/Mileage: (\d*,{,1}\d+)/)[1]
  end

  # Returns the listing's sale price
  def self.sale_price(doc)
    value = doc.css('.price').text
    (value.include? 'Call') ? 'Call' : value
  end

  # Returns the seller's address
  def self.seller_location(doc)
    doc.css('strong')[1].text.strip
  end

  # Returns the seller's name
  def self.seller_name(doc)
    doc.css('strong')[0].text.strip
  end

  PHONE_PATTERN = '\(\d\d\d\) \d\d\d-\d\d\d\d'

  # Returns the seller's phone number, if it exists
  def self.seller_phone(doc, id, url_file)
    span = doc.css('span')
    if 1 < span.size
      match_data = span[0].text.match(/#{PHONE_PATTERN}/)
      match_data ? match_data.to_s : ''
    else
      seller_phone_private(url_file, id)
    end
  end

  # Returns the seller's phone number, if found in the raw HTML text
  def self.seller_phone_private(url_file, id)
    match_data = nil
    open(url_file).detect { |line| match_data = line.match(/#{PHONE_PATTERN}/) if line.include? ('aiGetPhoneNumber'+id) }
    match_data ? match_data.to_s : ''
  end

  # Returns listing start date
  def self.start_date(doc)
    doc.css('.listingDate').text
  end

  # Returns the summary listing's title
  def self.title(doc)
    doc.css('.aiResultTitle h3').text  # '2010 Ford Explorer XL'
  end

  # Returns the year, make, and model from the title string
  # NOTE: It is assumed that Make will be one word.
  #       Otherwise, likely will need a database of Make names to match against.
  def self.title_parts(doc)
    title_parts = title(doc).split(' ')
    year = title_parts[0]  # year
    make = title_parts[1]  # make
    model = title_parts.last(title_parts.size - 2).join(' ')  # model
    [year, make, model]
  end
end
