class CLI
  # This is the command line interface for the classified app

  def initialize(item_class, url, page_size:10)
    @item_class = item_class
    @page_size  = page_size
    Scraper.create_listings(url, @item_class)
  end

  # Begin executing command line interface
  def run
    start_index =  0  # summary display start item
    end_index   = -1  # summary display end item
    user_input  = ''  # command line input

    # Display advance loop
    while true
      start_index = end_index + 1
      start_index = 0 if start_index == Listing.all(@item_class).size

      # Command input loop
      begin
        end_index = start_index + @page_size-1  # if page size changes inside this loop, make adjustments.
        end_index = Listing.all(@item_class).size-1 if end_index >= Listing.all(@item_class).size

        # Display a page of listings
        Listing.print_summary(@item_class, start_index, end_index) if user_input != 'h'

        # Get user imput
        user_input = prompt('Command (or h for help): ')

        # Process user input
        exit if process_user_input(user_input) == false

      end until user_input == ''  # then display next page of summaries.
    end  # CLI loop
  end

  ## PRIVATE METHODS
  private

  # Returns whether or not to continue executing program
  def process_user_input(user_input)
    if user_input == 'h'
      display_help
      true
    elsif user_input == 'p'
      tmp_page_size = prompt('Enter new page size: ').to_i
      @page_size = tmp_page_size if tmp_page_size > 0
      true
    elsif user_input == 'q'
      false
    elsif user_input.to_i > 0
      Listing.all(@item_class)[user_input.to_i-1].print_detail(user_input.to_i)
      prompt ('Press Enter to continue...')
      true
    else
      true
    end
  end

  # Display command help
  def display_help
    puts '  To continue scrolling, press Enter.',
         '  For listing detail, enter listing number and press Enter',
         '  To terminate, type q and press Enter.',
         '  To display this help, type h and press Enter.'
  end

  # Display prompt string and return user's input
  def prompt(string)
    print yellow(string)
    gets.chomp
  end

  # Format string to display in color yellow
  def yellow(string)
     "\e[33m#{string}\e[0m"
   end
end
