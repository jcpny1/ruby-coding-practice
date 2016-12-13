class Automobile < Vehicle
  # .Automobile describes a Vehicle type of Automobile

  @@ATTR_COLUMN_WIDTHS  = [12, 10]
  @@SUMMARY_COL_FORMATS = [[24,'l'], [7,'r'], [8,'r']]

  def initialize(year, make, model, mileage, price, condition, detail_link)
    super(year, make, model, price, condition, detail_link)
    @mileage = mileage
  end

  # Return attribute field width for given column
  def attr_width(col)
    @@ATTR_COLUMN_WIDTHS[col-1]
  end

  # Return a summary listing detail row
  def summary_detail
    Listing.fmt_cols([@title, @mileage, @price], @@SUMMARY_COL_FORMATS)
  end

  # Return the summary listing summary title row
  def self.summary_header
    Listing.fmt_cols(['Vehicle', 'Mileage', 'Price '], @@SUMMARY_COL_FORMATS)
  end
end
