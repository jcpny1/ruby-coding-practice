class Listing
  # .Listing describes a classified advertisement.
  # A Listing has one item and one seller, along with listing-based attributes such as the listing start date.

  @@all_automobile_listings = []

  attr_reader :id, :item, :seller, :start_date

  def self.all(item_class)
    case item_class.class
    when Automobile.class
      @@all_automobile_listings
    else
      puts "Unsupported item type"
    end
  end

  def initialize(id, item, seller, start_date)
    @id = id
    @item = item
    @seller = seller
    @start_date = start_date
    case item.class
    when Automobile.class
      @@all_automobile_listings << self
    else
      puts "Unsupported item type"
    end
  end

  ATTRIBUTE_RJUST = 14

  def print_detail(item_number)
    Scraper.get_detail_values(@item.class, item.detail_link, item.detail_values, item.condition, seller.phone) if item.detail_values.empty?
    puts '', "#{item.summary_detail(item_number)} #{Listing.lfmt(seller.name,28)} #{Listing.lfmt(seller.location,32)} #{start_date}"
    item.detail_values.each { |attribute, value| puts "#{attribute.to_s.ljust(12).rjust(ATTRIBUTE_RJUST)}: #{format_value(value)}" }
  end

  VALUE_RJUST =  ATTRIBUTE_RJUST + 2
  MAX_LINE_LENGTH = 100
  NEW_DETAIL_LINE = "\n" + (' ' * VALUE_RJUST)

  def format_value(string)
    return string if string.size <= MAX_LINE_LENGTH
    new_string = ''
    line_len = 0
    string.split(' ').each { |word|
      if (line_len += word.size + 1) > MAX_LINE_LENGTH
        if line_len > (MAX_LINE_LENGTH + 2)  # allow a word to extend over MAX_LINE_LENGTH a bit.
          new_string += NEW_DETAIL_LINE
          line_len = 0
        end
      end
      new_string += "#{word} "
    }
    new_string
  end

  def self.print_summary(item_class, start_index, end_index)
    case item_class.class
    when Automobile.class
      puts "#{Automobile.summary_header} #{Listing.lfmt('Seller',28)} #{Listing.lfmt('Location',32)} #{'ListedDate'}"
      all(item_class)[start_index..end_index].each_with_index { |listing, index| puts "#{listing.item.summary_detail(start_index+index+1)} #{Listing.lfmt(listing.seller.name,28)} #{Listing.lfmt(listing.seller.location,32)} #{listing.start_date}" }
    else
      puts "Unsupported item type"
    end
  end

  def self.lfmt(string, size)
    string.slice(0,size).ljust(size)
  end

  def self.rfmt(string, size)
    string.slice(0,size).rjust(size)
  end

  def self.seller_listings(listing_seller)
    results = []
    @@all.each { |listing| results << listing if listing.seller == listing_seller }
    results
  end

  def seller_location
    seller.location
  end

  def seller_name
    seller.name
  end

  def seller_phone
    seller.phone
  end
end
