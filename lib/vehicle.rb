class Vehicle < Item
  # .Vehicle describes a Vehicle type of item.
  # It is expected to be subclassed based on the type of vehicle (e.g., automobile, boat, motorcycle, etc.)

  def initialize(year, make, model, price, condition, detail_link)
    super("#{year} #{make} #{model}", price, condition, detail_link)
    @year  = year
    @make  = make
    @model = model
  end

  def self.summary_header
    "OVERRIDE ME!"
  end
end
