class Seller
  # .Seller describes the entity that is selling the .Item in a .Listing.

  @@all = []

  private_class_method :new

  attr_reader :name, :location, :phone

  def self.all
    @@all
  end

  def self.find_or_create(name, location, phone)
    seller = find_seller(name, location, phone)
    if seller == nil
      seller = new(name, location, phone)
      @@all << seller
    end
    seller
  end

  def self.find_seller(name, location, phone)
    @@all.find { |seller| seller.name == name && seller.location == location && seller.phone == phone }
  end

  def initialize(name, location, phone)
    @name = name
    @location = location
    @phone = phone
  end

end
