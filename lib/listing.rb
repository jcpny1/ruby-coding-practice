class Listing
  # .Listing describes a classified advertisement
  # A Listing has one item and one seller, along with listing-based attributes such as the listing start date

  @@all_listings = []

  def initialize(id, item, seller, start_date)
    @id = id
    @item = item
    @seller = seller
    @start_date = start_date
    Listing.all << self
  end

  # Empty list of created objects
  def self.clear
    Item.clear
    Seller.clear
    all.clear
  end

  # Prints a detail listing for a single item
  def print_detail(item_number)
    puts '',
         self.summary_detail_row(item_number),
         @item.details_to_string

    # display seller phone number if there was no phone number found in the detail listing.
    puts "#{Listing.fmt_detail_attr('Phone'    )}: #{Listing.fmt_detail_val(@seller.phone)}" if !@item.get_detail_phone

    puts "#{Listing.fmt_detail_attr('Listing #')}: #{Listing.fmt_detail_val(@id)}"
  end

  # Prints the specified summary listings for the specified item subclass
  def self.print_summary(item_class, start_index, end_index)
    puts "    #{item_class.summary_header} #{Seller.summary_header} #{Listing.lfmt('List Date', 10)}"
    all[start_index..end_index].each_with_index { |listing, index| puts listing.summary_detail_row(start_index+index+1) }
  end

  # Prints a summary detail row
  def summary_detail_row(item_number)
    "#{(item_number).to_s.rjust(2)}. #{@item.summary_detail} #{@seller.summary_detail} #{Listing.lfmt(@start_date, 10)}"
  end

  # Formats an array of strings according to an array of formats
  def self.fmt_cols(values, formats)
    result = ''
    values.each_with_index { |value, index| result += "#{Listing.fmt_col(value, formats[index][0], formats[index][1])} " }
    result
  end

  # Format a detail attribute
  def self.fmt_detail_attr(string)
    "  #{lfmt(string, 12)}"
  end

  MAX_LINE_LENGTH = 100

  # Format a detail value (with wrap if necessary)
  def self.fmt_detail_val(string)
    return string if string.size <= MAX_LINE_LENGTH
    new_string = ''
    line_len = 0
    string.split(' ').each { |word|
      if (line_len += word.size + 1) > MAX_LINE_LENGTH
        if line_len > (MAX_LINE_LENGTH + 2)               # Allow a word to extend over MAX_LINE_LENGTH a bit to avoid large
          new_string += "\n  #{self.fmt_detail_attr('')}" # empty spaces on right margin due to large words not quite fitting.
          line_len = 0
        end
      end
      new_string += "#{word} "
    }
    new_string
  end

  ## PRIVATE METHODS
  private

  # Return array of listings of given item_class
  def self.all
    @@all_listings
  end

  # Format a column
  def self.fmt_col(str, width, justify)
    case justify
    when 'l'
      "#{lfmt(str, width)}"
    when 'r'
      "#{rfmt(str, width)}"
    else
      "error"
    end
  end

  # Left justify string and pad or trim to size
  def self.lfmt(string, size)
    string.slice(0,size).ljust(size)
  end

  # Right justify string and pad or trim to size
  def self.rfmt(string, size)
    string.slice(0,size).rjust(size)
  end
end
