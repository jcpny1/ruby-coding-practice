class Item
  # .Item describes the thing in a listing that is for sale.
  # It is expected to be subclassed based on the type of item for sale (e.g., vehicle, clothing, furniture, etc.)
  # To improve performance, detail_values are only loaded on demand (from the detail_link url).

  attr_accessor :detail_values
  attr_reader   :condition, :detail_link, :price, :title

  def initialize(title, price, condition, detail_link)
    @title = title
    @price = price
    @detail_link = detail_link
    @condition = condition
    @detail_values = {}
  end

  def summary_detail
    "OVERRIDE ME!"
  end

  def self.summary_header
    "OVERRIDE ME!"
  end
end
