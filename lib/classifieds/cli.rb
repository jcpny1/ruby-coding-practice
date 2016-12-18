class Classifieds::CLI  # is the command line interface for the classified app

  def initialize
    @start_index = 0  # indexes for summary listing array access.
    @end_index   = 0
    @item_class  = nil
  end

  # Begin executing command line interface
  def run(page_size:10)
    @page_size = page_size
    user_input = ''
    select_item_type

    while true  # do CLI Loop
      @start_index = @end_index + 1  # Advance to next page of listings.
      @start_index = 0 if @start_index == Classifieds::Listing.all.size  # Go back to beginning if end is reached.

      begin  # Command input loop
        @end_index = @start_index + @page_size-1  # if page size changes inside this loop, adjust end index.
        @end_index = Classifieds::Listing.all.size-1 if @end_index >= Classifieds::Listing.all.size

        Classifieds::Listing.print_summary(@item_class, @start_index, @end_index) if user_input != 'h'  # Display a page of listings.
        user_input = Classifieds::CLI.prompt 'Command (or h for help): '  # Get user input.
        exit if !process_user_input(user_input)          # Process user input.
      end until user_input == ''  # then display next page of summaries.
    end  # do CLI loop
  end

  ## PRIVATE METHODS
  private

  # Display command help
  def self.display_help
    puts '  To continue scrolling, press Enter.',
         '  For listing detail, enter listing number and press Enter',
         '  To change item type, type i and press Enter',
         '  To terminate program, type q and press Enter.',
#        '  For a seller list, type s and press Enter.',
         '  To display this help, type h and press Enter.'
  end

  # Returns whether or not to continue executing program
  def process_user_input(user_input)
    continue_program = true

    case user_input
    when 'h'
      Classifieds::CLI.display_help
    when 'i'
      select_item_type
    when 'p'
      tmp_page_size = Classifieds::CLI.prompt('Enter new page size: ').to_i
      @page_size = tmp_page_size if 0 < tmp_page_size
    when 'q'
      continue_program = false
#    when 's'
#      # list sellers instead of items
    when ''
      # display next summary rows
    else
      if (item_number = user_input.to_i).between?(1, Classifieds::Listing.all.size)
        Classifieds::Listing.all[item_number-1].print_detail(item_number)
      else
        STDERR.puts Classifieds::CLI.red('Invalid selection')
      end
      Classifieds::CLI.prompt 'Press Enter to continue...'
    end
    continue_program
  end

  # Display prompt string and return user's input
  def self.prompt(string)
    print Classifieds::CLI.yellow(string)
    gets.chomp
  end

  # Format string to display in the color red
  def self.red(string)
    "\e[31m#{string}\e[0m"
  end

  def select_item_type
    begin
      valid_input = false

      puts 'Available item types:',
           '  1. Automobile',
           '  2. Boat'
      user_input = Classifieds::CLI.prompt 'Enter your selection number: '

      case user_input.to_i
      when 1
        valid_input  = true
        @item_class  = Classifieds::Auto
        @summary_url = 'http://long-island-cars.newsday.com/motors/results/car?maxYear=2010&radius=0&min_price=1000&view=List_Detail&sort=Price+desc%2C+Priority+desc&rows=50'
      when 2
        valid_input  = true
        @item_class  = Classifieds::Boat
        @summary_url = 'http://www.boattrader.com/search-results/NewOrUsed-used/Type-power/Category-all/Zip-10030/Radius-100/Price-5000,150000/Sort-Price:DESC/Page-1,50?'
      else
        STDERR.puts Classifieds::CLI.red('Invalid selection')
      end
    end while valid_input == false

    Classifieds::Listing.clear_all
    Classifieds::Listing.scrape_listings(@item_class, @summary_url)
    @start_index =  0  # summary display start item
    @end_index   = -1  # summary display end item
  end

  # Format string to display in the color yellow
  def self.yellow(string)
    "\e[33m#{string}\e[0m"
  end
end
