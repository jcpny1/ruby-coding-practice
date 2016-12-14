class Classifieds::Boat < Classifieds::Vehicle  # describes a Vehicle type of: Boat

  @@ATTR_COLUMN_WIDTHS  = [15, 14]
  @@SUMMARY_COL_FORMATS = [[24,'l'], [8,'r']]  # [width, justification]

  def initialize(year, make, model, price, condition, detail_link)
    super(year, make, model, price, condition, detail_link)
  end

  # Return attribute field width for given column
  def attr_width(col)
    @@ATTR_COLUMN_WIDTHS[col-1]
  end

  # Creates listings from summary web page
  def self.scrape_results_page(results_url, results_url_file, results_doc)
    Classifieds::BoatScraper.scrape_results_page(results_url, results_url_file, results_doc, self)
  end

  # Returns detail attributes and values in detail_values hash
  def self.scrape_results_detail_page(detail_doc, item_condition, detail_values)
    Classifieds::BoatScraper.scrape_results_detail_page(detail_doc, item_condition, detail_values)
  end

  # Returns a summary listing data row
  def summary_detail
    Classifieds::Listing.fmt_cols([@title, @price], @@SUMMARY_COL_FORMATS)
  end

  # Returns the summary listing title row
  def self.summary_header
    Classifieds::Listing.fmt_cols(['Boat', 'Price '], @@SUMMARY_COL_FORMATS)
  end
end
