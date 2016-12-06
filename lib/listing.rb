class Listing

# .Listing describes a classified advertisement and contains one item and one seller, along with a listing start date.

  @@all = []

  attr_reader :id, :item, :seller, :start_date

  def self.all
    @@all
  end

  def initialize(id, item, seller, start_date)
    @id = id
    @item = item
    @seller = seller
    @start_date = start_date
    @@all << self
  end

  def description
    item.description
  end

  def detail_link
    item.detail_link
  end

  def mileage
    item.is_a?(Automobile) ? item.mileage : 0
  end

  def price
    item.price
  end

  ATTRIBUTE_RJUST = 14

  def print_detail(item_number)
    Scraper.get_detail_values(detail_link, item.detail_values, item.condition, seller.phone) if item.detail_values.empty?
    puts '', summary(item_number)
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

  #keep #summary and #summary_header in sync
  def summary(item_number)
#replace with printf style format?
    "#{(item_number).to_s.rjust(2)}. #{Listing.lfmt(title,34)} #{Listing.rfmt(mileage,7)} #{Listing.lfmt(seller_name,28)} #{Listing.lfmt(seller_location,32)} #{Listing.rfmt(price,8)} #{start_date}"
  end

  #keep #summary and #summary_header in sync
  def self.summary_header
#replace with printf style format?
    "#{' '.rjust(2)}  #{lfmt('Vehicle',34)} #{rfmt('Mileage',7)} #{lfmt('Seller',28)} #{lfmt('Location',32)} #{rfmt('Price ',8)} #{'ListedDate'}"
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

  def title
    item.title
  end
end
