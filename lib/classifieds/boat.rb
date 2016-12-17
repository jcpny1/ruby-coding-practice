class Classifieds::Boat < Classifieds::Vehicle  # describes a Vehicle type of: Boat

  SUMMARY_COL_FORMATS = [[32,'l'], [9,'r']]  # [width, justification]

  def initialize(year, make, model, price, condition, detail_link)
    super(year, make, model, price, condition, detail_link)
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
    Classifieds::Listing.format_cols([@title, @price], SUMMARY_COL_FORMATS)
  end

  # Returns the summary listing title row
  def self.summary_header
    Classifieds::Listing.format_cols(['Boat', 'Price '], SUMMARY_COL_FORMATS)
  end
end
