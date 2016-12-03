class CLI
  def initialize
    listings = []
    auto_url = 'http://long-island-cars.newsday.com/motors/results/Ford/in/10010/car?maxYear=2010&radius=150&condition=used&view=List_Detail&sort=geodist%28%29+asc&rows=50'
    Scraper.new.create_auto_listings(auto_url, listings)
    Listing.all.each { |listing| listing.print_summary }
    puts Seller.all.collect { |seller| seller.name }
    Seller.all.each { |seller|
      puts seller.name
      Listing.seller_listings(seller).each { |listing|
        print '  '
        listing.print_summary
      }
    }
  end
end
