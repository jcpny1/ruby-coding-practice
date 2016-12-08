class Item
  # .Item describes the thing in a listing that is for sale.
  # It is expected to be subclassed based on the type of item for sale (e.g., vehicle, clothing, furniture, etc.)
  # To improve performance, detail_values are only loaded on demand (from the detail url).

  attr_accessor :detail_values
  attr_reader   :condition, :detail_url, :price, :title

  def initialize(title, price, condition, detail_url)
    @title = title
    @price = price
    @detail_url = detail_url
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
