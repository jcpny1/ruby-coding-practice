class Scraper

# .Scraper converts Newsday classified advertisement HTML into objects

  def self.create_auto_listings(url, listings)
    open_url = open(url, :read_timeout=>10)
    doc = Nokogiri::HTML(open_url)
    doc.css('.aiResultsWrapper').each { |auto_result|
      id = self.get_listing_id(auto_result)

      title = get_title(auto_result)
      title_parts = split_title(title)  # [year, make, model]

      description_pod_div = auto_result.css('.aiDescriptionPod')
      start_date = get_date(description_pod_div)
      mileage = get_mileage(description_pod_div)
      price = get_price(description_pod_div)

      detail_link = get_detail_link(url, auto_result)
      condition = get_condition(detail_link)
      contact_div = auto_result.css('.contactLinks')
      seller_name = get_seller_name(contact_div)
      seller_location = get_seller_location(contact_div)
      seller_phone = get_seller_phone(contact_div, id, open_url)

      item = Automobile.new(title_parts[0], title_parts[1], title_parts[2], mileage, price, condition, detail_link)
      seller = Seller.find_or_create(seller_name, seller_location, seller_phone)
      listings << Listing.new(id, item, seller, start_date)
    }

    listings
  end

  def self.get_detail_values(detail_link, detail_values)
    detail_doc = Nokogiri::HTML(open(detail_link, :read_timeout=>10))
    detail_values['Description'] = detail_doc.css('.aiDetailsDescription')[0].children[2].text.strip
    detail_cells = get_detail_cells(detail_doc)
    index = 0
    while index < detail_cells.size
      attribute = detail_cells[index].text.chomp(':')
      value = detail_cells[index+1].text
      detail_values[attribute] = value
      index += 2
    end
#binding.pry
  end

  def self.get_condition(detail_link)
    if detail_link.include?('-used-')
      'sub(/Details/).used'
    elsif detail_link.include?('-new-')
      'new'
    elsif detail_link.include?('-certified-')
      'certified'
    else
      'unknown'
    end
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
    if mileage_text.include?('Available')
      'NA'
    else
      mileage_text[mileage_text.index(' ')+1..mileage_text.size-1]
    end
  end

  def self.get_price(description)
    price_text = description.css('.price').text
    if price_text.include?('Call')
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

  def self.get_seller_phone(contact, id, open_url)
    span = phone_parts = contact.css('span')
    if span.size > 1
      phone_parts = span[0].text.split(' ')
      "#{phone_parts[2]} #{phone_parts[3]}"
    else
      get_seller_phone_private(id, open_url)
    end
  end

  def self.get_seller_phone_private(id, open_url)
    tgt_line = ''
    phone_id = 'aiGetPhoneNumber' + id
      open(open_url).each_line { |line|
        if line.include?(phone_id)
          tgt_line = line
          break
        end
      }
    tgt_line.split("'")[1]
  end

  def self.get_title(auto_result)
    auto_result.css('.aiResultTitle h3').text  # '2010 Ford Explorer XL'
  end

  def self.split_title(title)
    title_parts = title.split(' ')
    year = title_parts[0]
    make = title_parts[1]
    model = title_parts.last(title_parts.size - 2).join(' ')
    [year, make, model]
  end

end
