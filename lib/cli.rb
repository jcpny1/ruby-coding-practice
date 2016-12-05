class CLI

  DISPLAY_LINE_COUNT = 5

  def initialize
    listings = []
    user_input = ''

    auto_url = 'http://long-island-cars.newsday.com/motors/results/Ford/in/10010/car?maxYear=2010&radius=150&condition=used&view=List_Detail&sort=geodist%28%29+asc&rows=50'
    Scraper.create_auto_listings(auto_url, listings)

    start_index = 0
    end_index = Listing.all.size-1

    while true
      start_index = end_index + 1
      start_index = 0 if start_index == Listing.all.size

      end_index = start_index + DISPLAY_LINE_COUNT-1
      end_index = Listing.all.size-1 if end_index >= Listing.all.size

      begin
        if user_input != 'h'
          Listing.all[start_index..end_index].each_with_index { |listing, index| puts "#{(start_index+index+1).to_s.rjust(2)}. #{listing.summary}" }
        end

        print yellow('Command (or h for help): ')
        user_input = gets.chomp

        if user_input == 'h'
          display_help
        elsif user_input == 'q'
          exit
        elsif user_input.to_i > 0
          Listing.all[user_input.to_i-1].print_detail
          print yellow('Press Enter to continue...')
          gets
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

  def yellow(string)
     "\e[33m#{string}\e[0m"
   end

end
