class Automobile < Vehicle
  # .Automobile describes a Vehicle type of Automobile

  attr_reader :mileage

    def initialize(year, make, model, mileage, price, condition, detail_link)
      super(year, make, model, price, condition, detail_link)
      @mileage = mileage
    end

    # Return the summary listing summary title row
    def self.summary_header
      "#{Listing.fmt_col(1,'')} #{Listing.fmt_col(2,'Vehicle')} #{Listing.fmt_col(3,'Mileage')} #{Listing.fmt_col(4,'Price ')}"
    end

    # Return a summary listing detail row
    def summary_detail
      "#{Listing.fmt_col(2,title)} #{Listing.fmt_col(3,mileage)} #{Listing.fmt_col(4,price)}"
    end
end
