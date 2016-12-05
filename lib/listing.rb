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

  def print_detail
    if item.detail_values.size == 0
      Scraper.get_auto_listing_details(detail_link, item.detail_values)
    end
    puts "\n", summary
    item.detail_values.each { |attribute, value| puts "  #{attribute.ljust(12)}: #{value}" }
  end

  def summary
#replace with printf style format?
    "#{title.ljust(30)} #{mileage.rjust(7)} #{seller_name.ljust(30)} #{seller_location.ljust(30)} #{price.rjust(8)} #{start_date}"
#    puts @seller.phone + '    ' + @id
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
