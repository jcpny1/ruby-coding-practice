class Classifieds::StringReverse

  # SUMMARY_COL_FORMATS = [[32,'l'], [7,'r'], [9,'r']]  # [width, justification]

  def initialize(year, make, model, mileage, price, condition, detail_link)
    super(year, make, model, price, condition, detail_link)
    @mileage = mileage
  end

  # Creates listings from summary web page
  def self.scrape_results_page(results_url, results_url_file, results_doc)
    Classifieds::AutoScraper.scrape_results_page(results_url, results_url_file, results_doc, self)
  end

  # Returns detail attributes and values in detail_values hash
  def self.scrape_results_detail_page(detail_doc, item_condition, detail_values)
    Classifieds::AutoScraper.scrape_results_detail_page(detail_doc, item_condition, detail_values)
  end

  # Returns a summary listing data row
  def summary_detail
    Classifieds::Listing.format_cols([@title, @mileage, @price], SUMMARY_COL_FORMATS)
  end

  # Returns the summary listing title row
  def self.summary_header
    Classifieds::Listing.format_cols(['Vehicle', 'Mileage', 'Price '], SUMMARY_COL_FORMATS)
  end
end
