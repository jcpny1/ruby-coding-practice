class Classifieds::Vehicle < Classifieds::Item  # describes an Item of type Vehicle
  # It is expected to be subclassed based on the type of vehicle (e.g., automobile, boat, motorcycle, etc.)

  def initialize(year, make, model, price, condition, detail_link)
    super("#{year} #{make} #{model}", price, condition, detail_link)
    @year  = year
    @make  = make
    @model = model
  end
end
