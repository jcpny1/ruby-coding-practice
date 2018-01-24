class Classifieds::CLI  # is the command line interface for the classified app

  # Begin executing command line interface
  def run
    while select_item_type  # do CLI Loop
    end
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
      continue_app = true
      valid_input = false

      puts 'Available item types:',
        '  1. String Reverse',
        '  2. Running mean',
        ' 99. Exit'
      user_input = Classifieds::CLI.prompt 'Enter your selection number: '

      case user_input.to_i
      when 1
        valid_input  = true
        Classifieds::StringReverse
      when 2
        valid_input  = true
        @item_class  = Classifieds::Boat
        @summary_url = 'http://www.boattrader.com/search-results/NewOrUsed-used/Type-power/Category-all/Zip-10030/Radius-100/Price-5000,150000/Sort-Price:DESC/Page-1,50?'
      when 99
        valid_input  = true
        continue_app = false
      else
        STDERR.puts Classifieds::CLI.red('Invalid selection')
      end
    end while valid_input == false
    continue_app
  end

  # Format string to display in the color yellow
  def self.yellow(string)
    "\e[33m#{string}\e[0m"
  end
end
