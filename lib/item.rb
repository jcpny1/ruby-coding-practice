class Item
  # .Item describes the thing in a listing that is for sale
  # It is expected to be subclassed based on the type of item for sale (e.g., vehicle, clothing, furniture, etc.)
  # To improve response time, an item's detail_values are only loaded on demand (from the detail url)

  attr_accessor :detail_values
  attr_reader   :condition, :detail_url, :price, :title

  def initialize(title, price, condition, detail_url)
    @title = title
    @price = price
    @detail_url = detail_url
    @condition = condition
    @detail_values = {}
  end

  # Return the detail rows
  def details_to_string
    result = ''
    Scraper.get_listing_details(self.class, @detail_url, @condition, @detail_values) if @detail_values.empty?
    @detail_values.each { |attribute, value| result += "#{Listing.fmt_detail_attr(attribute.to_s)}: #{Listing.fmt_detail_val(value)}\n" }
    result
  end
end
