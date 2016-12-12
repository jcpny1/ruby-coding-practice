class CLI
  # This is the command line interface for the classified app

  # Begin executing command line interface
  def self.run(page_size:10)
    @page_size = page_size
    user_input = ''
    set_listing_type

    # Display advance loop
    while true
      @start_index = @end_index + 1
      @start_index = 0 if @start_index == Listing.all.size

      # Command input loop
      begin
        @end_index = @start_index + @page_size-1  # if page size changes inside this loop, make adjustments.
        @end_index = Listing.all.size-1 if @end_index >= Listing.all.size

        # Display a page of listings
        Listing.print_summary(@item_class, @start_index, @end_index) if user_input != 'h'

        # Get user imput
        user_input = prompt 'Command (or h for help): '

        # Process user input
        exit if !process_user_input(user_input)

      end until user_input == ''  # then display next page of summaries.
    end  # CLI loop
  end

  ## PRIVATE METHODS
  private

  # Display command help
  def self.display_help
    puts '  To continue scrolling, press Enter.',
         '  For listing detail, enter listing number and press Enter',
         '  To change listing type, type l and press Enter',
         '  To terminate program, type q and press Enter.',
         '  To display this help, type h and press Enter.'
  end

  # Returns whether or not to continue executing program
  def self.process_user_input(user_input)
    continue_program = true

    case user_input
    when 'h'
      display_help
    when 'l'
      set_listing_type
    when 'p'
      tmp_page_size = prompt('Enter new page size: ').to_i
      @page_size = tmp_page_size if 0 < tmp_page_size
    when 'q'
      continue_program = false
    else
      if 0 < user_input.to_i
        index = user_input.to_i - 1
        if index > Listing.all.size
          STDERR.puts red('Invalid selection')
        else
          Listing.all[index].print_detail(index+1)
        end
        prompt 'Press Enter to continue...'
      end
    end
    continue_program
  end

  # Display prompt string and return user's input
  def self.prompt(string)
    print yellow(string)
    gets.chomp
  end

  # Format string to display in the color red
  def self.red(string)
    "\e[31m#{string}\e[0m"
  end

  def self.set_listing_type
    begin
      valid_input = false

      puts 'Available listing types:',
           '  1. Automobile',
           '  2. Boat'
      user_input = prompt 'Enter your selection number: '

      case user_input.to_i
      when 1
        valid_input = true
        @item_class  = Automobile
        @summary_url = 'http://long-island-cars.newsday.com/motors/results/car?maxYear=2010&radius=0&min_price=1000&view=List_Detail&sort=Price+desc%2C+Priority+desc&rows=50'
      when 2
        valid_input = true
        @item_class  = Boat
        @summary_url = 'http://www.boattrader.com/search-results/NewOrUsed-used/Type-power/Category-all/Zip-10030/Radius-100/Price-5000,150000/Sort-Price:DESC/Page-1,50?'
      else
        STDERR.puts red('Invalid selection')
      end
    end while valid_input == false

    Scraper.create_listings(@summary_url, @item_class)
    @start_index =  0  # summary display start item
    @end_index   = -1  # summary display end item
  end

  # Format string to display in the color yellow
  def self.yellow(string)
    "\e[33m#{string}\e[0m"
  end
end
