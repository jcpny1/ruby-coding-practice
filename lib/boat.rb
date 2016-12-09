class Boat < Vehicle
  # .Boat describes a Vehicle type of Boat

  attr_reader :hours, :length

    def initialize(year, make, model, hours, length, price, condition, detail_link)
      super(year, make, model, price, condition, detail_link)
      @hours = hours
      @length = length
    end

    # Return the summary listing summary title row
    def self.summary_header
      "#{Listing.fmt_col(1,'')} #{Listing.fmt_col(2,'Boat')} #{Listing.fmt_col(3,'Hours')} #{Listing.fmt_col(4,'Price ')}"
    end

    # Return a summary listing detail row
    def summary_detail
      "#{Listing.fmt_col(2,title)} #{Listing.fmt_col(3,hours)} #{Listing.fmt_col(4,price)}"
    end
end
