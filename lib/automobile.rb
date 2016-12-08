class Automobile < Vehicle
  # .Automobile describes an automobile type of Vehicle

  attr_reader :mileage

    def initialize(year, make, model, mileage, price, condition, detail_link)
      super(year, make, model, price, condition, detail_link)
      @mileage = mileage
    end

    #keep #summary_header and #summary_detail aligned
    def self.summary_header
      "#{' '.rjust(2)}  #{Listing.lfmt('Vehicle',34)} #{Listing.rfmt('Mileage',7)} #{Listing.rfmt('Price ',8)}"
    end

    #keep #summary_header and #summary_detail aligned
    def summary_detail(item_number)
      "#{(item_number).to_s.rjust(2)}. #{Listing.lfmt(title,34)} #{Listing.rfmt(mileage,7)} #{Listing.rfmt(price,8)}"
    end
end
