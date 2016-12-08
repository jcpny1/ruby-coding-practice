class Scraper
  # .Scraper converts a Newsday classified advertisement results web page into objects

  def self.create_listings(url, item_class)
    open_url = open(url, :read_timeout=>10)
    doc = Nokogiri::HTML(open_url)
    case item_class.class
    when Automobile.class
      scrape_automobile_results_page(url, open_url, doc, item_class)
    else
      puts "Unsupported item type"
    end
  end

  def self.get_detail_values(item_class, detail_link, detail_values, listing_id, condition, phone)
    case item_class.class
    when Automobile.class
      scrape_automobile_results_detail_page(detail_link, detail_values, listing_id, condition, phone)
    else
      puts "Unsupported item type"
    end
  end

## PRIVATE METHODS
private

  def self.get_condition(detail_link)
    detail_link.match(/[a-z0-9]-(certified|new|used)-[0-9]/)[1].capitalize
  end

  def self.get_date(description)
    description.css('.listingDate').text
  end

  def self.get_detail_cells(detail_doc)
    detail_doc.css('.aiDetailAdDetails td')
  end

  def self.get_detail_link(url, auto_result)
    url_parts = url.split('/')
    url_parts[0] + '//' + url_parts[2] + auto_result.css('.aiResultTitle h3 a')[0]['href']
  end

  def self.get_listing_id(auto_result)
    results_main_div = auto_result.css('.aiResultsMainDiv')[0]['id']
    results_main_div[16..results_main_div.size-1]
  end

  def self.get_mileage(description)
    mileage_text = description.css('.listingType').text  # 'Mileage: xx,xxx'
    if mileage_text.include? 'Available'
      'NA'
    else
      mileage_text[mileage_text.index(' ')+1..mileage_text.size-1]
    end
  end

  def self.get_price(description)
    price_text = description.css('.price').text
    if price_text.include? 'Call'
      'Call'
    else
      price_text
    end
  end

  def self.get_seller_location(contact)
    contact.css('strong')[1].text.strip
  end

  def self.get_seller_name(contact)
    contact.css('strong')[0].text.strip
  end

  PHONE_PATTERN = '\(\d\d\d\) \d\d\d-\d\d\d\d'

  def self.get_seller_phone(contact, id, open_url)
    phone_number = nil
    span = contact.css('span')
    if span.size > 1
      match_data = span[0].text.match(/#{PHONE_PATTERN}/)
      phone_number = match_data[0] if match_data != nil
    end
    phone_number = get_seller_phone_private(id, open_url) if phone_number == nil
    phone_number
  end

  def self.get_seller_phone_private(id, open_url)
    phone_number = ''
    phone_id = 'aiGetPhoneNumber' + id
    open(open_url).detect { |line|
      match_data = line.match(/#{PHONE_PATTERN}/) if line.include? phone_id
      phone_number = match_data[0] if match_data != nil
    }
    phone_number
  end

  def self.get_title(auto_result)
    auto_result.css('.aiResultTitle h3').text  # '2010 Ford Explorer XL'
  end

  def self.scrape_automobile_results_page(url, open_url, doc, item_class)
    doc.css('.aiResultsWrapper').each { |result|
      id = self.get_listing_id(result)

      title = get_title(result)
      title_parts = split_title(title)  # [year, make, model]

      description_pod_div = result.css('.aiDescriptionPod')
      start_date = get_date(description_pod_div)
      mileage = get_mileage(description_pod_div)
      price = get_price(description_pod_div)

      detail_link = get_detail_link(url, result)
      condition = get_condition(detail_link)
      contact_div = result.css('.contactLinks')
      seller_name = get_seller_name(contact_div)
      seller_location = get_seller_location(contact_div)
      seller_phone = get_seller_phone(contact_div, id, open_url)

      item = item_class.new(title_parts[0], title_parts[1], title_parts[2], mileage, price, condition, detail_link)
      seller = Seller.find_or_create(seller_name, seller_location, seller_phone)
      Listing.new(id, item, seller, start_date)
    }
  end

  def self.scrape_automobile_results_detail_page(detail_link, detail_values, listing_id, condition, phone)
    detail_doc = Nokogiri::HTML(open(detail_link, :read_timeout=>10))
    detail_values['Description'.to_sym] = detail_doc.css('.aiDetailsDescription')[0].children[2].text.strip
    detail_values['Listing #'.to_sym] = listing_id
    detail_values['Condition'.to_sym] = condition
    detail_values['Certified'.to_sym] = ''
    detail_values['Phone'.to_sym] = phone
    detail_cells = get_detail_cells(detail_doc)
    index = 0
    while index < detail_cells.size
      if "\u00A0" == detail_cells[index].text  && 'aiCPOiconDetail' == detail_cells[index].children[0].attributes['class'].content   # certified icon attribute does not have a value.
        detail_values[:Certified] = 'Yes'
        index += 1
      else
        attribute = detail_cells[index].text.chomp(':')
        value = detail_cells[index+1].text
        detail_values[attribute.to_sym] = value
        index += 2
      end
    end
  end

  def self.split_title(title)
    title_parts = title.split(' ')
    year = title_parts[0]
    make = title_parts[1]
    model = title_parts.last(title_parts.size - 2).join(' ')
    [year, make, model]
  end
end
