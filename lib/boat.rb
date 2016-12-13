class Boat < Vehicle
  # .Boat describes a Vehicle type of Boat

  @@ATTR_COLUMN_WIDTHS  = [15, 14]
  @@SUMMARY_COL_FORMATS = [[24,'l'], [8,'r']]  # width, justification

  def initialize(year, make, model, price, condition, detail_link)
    super(year, make, model, price, condition, detail_link)
  end

  # Return attribute field width for given column
  def attr_width(col)
    @@ATTR_COLUMN_WIDTHS[col-1]
  end

  # Return a summary listing detail row
  def summary_detail
    Listing.fmt_cols([@title, @price], @@SUMMARY_COL_FORMATS)
  end

  # Return the summary listing summary title row
  def self.summary_header
    Listing.fmt_cols(['Boat', 'Price '], @@SUMMARY_COL_FORMATS)
  end
end
