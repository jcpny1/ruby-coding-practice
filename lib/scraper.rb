class Scraper  # converts a classified advertisement web pages into Listing objects

  # Creates listings from summary web page
  def self.create_listings(item_class, results_url)
    results_url_file = open(results_url, :read_timeout=>10)
    results_doc = Nokogiri::HTML(results_url_file)
    item_class.scrape_results_page(results_url, results_url_file, results_doc)
  end

  # Returns detail attributes and values in detail_values hash
  def self.listing_details(item_class, detail_url, item_condition, detail_values)
    detail_doc = Nokogiri::HTML(open(detail_url, :read_timeout=>10))
    item_class.scrape_results_detail_page(detail_doc, item_condition, detail_values)
  end
end
