class Seller
  # .Seller describes the entity that is selling the .Item in a .Listing
  # A seller is uniquely identified by name + location + phone

  @@all = []  # contains all the Sellers

  attr_reader :name, :location, :phone

  private_class_method :new #  only allow #new from #find_or_create

  def initialize(name, location, phone)
    @name = name
    @location = location
    @phone = phone
    Seller.all << self
  end

  # Returns array of all sellers
  def self.all
    @@all
  end

  # Returns the specified seller, or creates a new one if not found in @@all
  def self.find_or_create(name, location, phone)
    (seller = find_seller(name, location, phone)) != nil ? seller : new(name, location, phone)
  end

  # Returns the specified seller from @all or nil if not found
  def self.find_seller(name, location, phone)
    all.find { |seller| seller.name == name && seller.location == location && seller.phone == phone }
  end
end
