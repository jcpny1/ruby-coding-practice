class Vehicle < Item

# .Vehicle describes something for sale. It is subclassed based on the type of vehicle (e.g., automobile, boat, motorcycle, etc.)

  def initialize(year, make, model, price, condition, detail_link)
    super("#{year} #{make} #{model}", price, condition, detail_link)
    @year  = year
    @make  = make
    @model = model
  end

end
