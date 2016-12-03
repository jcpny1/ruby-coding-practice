class Automobile < Vehicle

# .Automobile describes an automobile for sale.

  attr_reader :mileage

    def initialize(year, make, model, mileage, price, condition, detail_link)
      super(year, make, model, price, condition, detail_link)
      @mileage = mileage
    end

end
