class Scraper
  # .Scraper converts a Newsday classified advertisement results web page into objects

  # Creates listings from summary web page
  def self.create_listings(url, item_class)
    Listing.clear # clear out any existing listings.

    url_file = open(url, :read_timeout=>10)
    doc = Nokogiri::HTML(url_file)
    case item_class.name
    when 'Automobile'
      AutoScraper.scrape_results_page(url, url_file, doc, item_class)
    when 'Boat'
      BoatScraper.scrape_results_page(url, url_file, doc, item_class)
    else
      STDERR.puts 'Unsupported item type'
    end
  end

  # Returns detail attributes and values in detail_values hash
  def self.listing_details(item_class, detail_url, condition, detail_values)
    case item_class.name
    when 'Automobile'
      AutoScraper.scrape_results_detail_page(detail_url, condition, detail_values)
    when 'Boat'
      BoatScraper.scrape_results_detail_page(detail_url, condition, detail_values)
    else
      STDERR.puts "Unsupported item type"
    end
  end
end
