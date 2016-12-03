class Item

# .Item describes something for sale. It is subclassed based on the type of item (e.g., vehicle, clothing, furniture, etc.)

  @@all = []

  attr_reader :title, :price, :condition, :detail_link

  def initialize(title, price, condition, detail_link)
    @title = title
    @price = price
    @detail_link = detail_link
    @condition   = condition
  end

end
