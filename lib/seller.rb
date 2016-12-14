class Seller  # describes the entity that is selling the .Item in a .Listing
  # A seller is uniquely identified by name + location + phone

  @@SUMMARY_COL_FORMATS = [[28,'l'], [32,'l']]  # [width, justification]

  @@all_sellers = []

  attr_accessor :phone
  attr_reader   :name, :location, :phone

  private_class_method :new #  only allow #new from #find_or_create

  def initialize(name, location, phone)
    @name = name
    @location = location
    @phone = phone
    Seller.all << self
  end

  # Empty list of created objects
  def self.clear
    all.clear
  end

  # Returns the specified seller, or creates a new one if not found in @@all
  def self.find_or_create(name, location, phone)
    (seller = find_seller(name, location, phone)) != nil ? seller : new(name, location, phone)
  end

  # Returns the specified seller from @all or nil if not found
  def self.find_seller(name, location, phone)
    all.find { |seller| seller.name == name && seller.location == location && seller.phone == phone }
  end

  # Return a summary listing detail row
  def summary_detail
    Listing.fmt_cols([@name, @location], @@SUMMARY_COL_FORMATS)
  end

  # Return the summary listing summary title row
  def self.summary_header
    Listing.fmt_cols(['Seller', 'Location'], @@SUMMARY_COL_FORMATS)
  end

  ## PRIVATE METHODS
  private

  # Returns array of all sellers
  def self.all
    @@all_sellers
  end
end
