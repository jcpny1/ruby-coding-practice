class CLI

  DEFAULT_PAGE_SIZE = 10

  def initialize
    listings = []
    page_size = DEFAULT_PAGE_SIZE

    auto_url = 'http://long-island-cars.newsday.com/motors/results/car?maxYear=2010&radius=0&min_price=1000&view=List_Detail&sort=Price+desc%2C+Priority+desc&rows=50'
    Scraper.create_auto_listings(auto_url, listings)

    start_index =  0
    end_index   = -1
    user_input  = ''

    while true
      start_index = end_index + 1
      start_index = 0 if start_index == Listing.all.size

      begin
        end_index = start_index + page_size-1  # put inside loop in case page size changes
        end_index = Listing.all.size-1 if end_index >= Listing.all.size

        if user_input != 'h'
          puts Listing.summary_header
          Listing.all[start_index..end_index].each_with_index { |listing, index| puts listing.summary(start_index+index+1) }
        end

        user_input = prompt('Command (or h for help): ')

        if user_input == 'h'
          display_help
        elsif user_input == 'p'
          page_size = prompt('Enter new page size: ').to_i
          page_size = DEFAULT_PAGE_SIZE if page_size <= 0
        elsif user_input == 'q'
          exit
        elsif user_input.to_i > 0
          Listing.all[user_input.to_i-1].print_detail(user_input.to_i)
          prompt ('Press Enter to continue...')
        end
      end until user_input == ''
    end

    # puts Seller.all.collect { |seller| seller.name }
    # Seller.all.each { |seller|
    #   puts seller.name
    #   Listing.seller_listings(seller).each { |listing|
    #     print '  '
    #     listing.print_summary
    #   }
    # }
  end

  def display_help
    puts '  To continue scrolling, press Enter.'
    puts '  For listing detail, enter listing number and press Enter'
    puts '  To terminate, type q and press Enter.'
    puts '  To display this help, type h and press Enter.'
  end

  def prompt(string)
    print yellow(string)
    gets.chomp
  end

  def yellow(string)
     "\e[33m#{string}\e[0m"
   end

end
