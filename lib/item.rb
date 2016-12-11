class Item
  # .Item describes the thing in a listing that is for sale
  # It is expected to be subclassed based on the type of item for sale (e.g., vehicle, clothing, furniture, etc.)
  # To improve response time, an item's detail_values are only loaded on demand (from the detail url)

  @@all_items = []

  def initialize(title, price, condition, detail_url)
    @title = title
    @price = price
    @detail_url = detail_url
    @condition = condition
    @detail_values = {}
    Item.all << self
  end

  # Empty list of created objects
  def self.clear
    all.clear
  end

  # Return the detail rows
  def details_to_string
    result = ''
    Scraper.get_listing_details(self.class, @detail_url, @condition, @detail_values) if @detail_values.empty?
    @detail_values.each { |attribute, value| result += "#{Listing.fmt_detail_attr(attribute.to_s)}: #{Listing.fmt_detail_val(value)}\n" }
    result
  end

  def get_detail_phone
    @detail_values[:Phone]
  end

  ## PRIVATE METHODS
  private

  # Return array of listings of given item_class
  def self.all
    @@all_items
  end
end
