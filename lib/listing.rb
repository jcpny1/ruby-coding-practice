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

  def mileage
    item.is_a?(Automobile) ? item.mileage : 0
  end

  def price
    item.price
  end

  def print_detail
  end

  def print_summary
#replace with printf style format?
    puts "#{title.ljust(30)} #{mileage.rjust(7)}\t#{seller_name.ljust(30)}\t#{seller_location.ljust(30)}\t#{price.rjust(8)}\t#{start_date}"
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
