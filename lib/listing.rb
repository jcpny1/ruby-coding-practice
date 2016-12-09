class Listing
  # .Listing describes a classified advertisement
  # A Listing has one item and one seller, along with listing-based attributes such as the listing start date

  @@listings = []  # contains all the listings

  attr_reader :id, :item, :seller, :start_date

  def initialize(id, item, seller, start_date)
    @id = id
    @item = item
    @seller = seller
    @start_date = start_date
    Listing.all << self
  end

  # Return array of listings of given item_class
  def self.all
    @@listings
  end

  def self.clear
    @@listings.celar
  end

  # Prints a detail listing for a single item
  def print_detail(item_number)
    puts '',
         Listing.summary_detail_row(self, item_number),
         @item.details_to_string,
         "#{Listing.fmt_detail_attr('Phone'    )}: #{Listing.fmt_detail_val(@seller.phone)}",
         "#{Listing.fmt_detail_attr('Listing #')}: #{Listing.fmt_detail_val(@id)}"
  end

  # Prints the specified summary listings for the specified item subclass
  def self.print_summary(item_class, start_index, end_index)
    puts "#{item_class.summary_header} #{fmt_col(5,'Seller')} #{fmt_col(6,'Location')} #{fmt_col(7,'List Date')}"
    all[start_index..end_index].each_with_index { |listing, index| puts summary_detail_row(listing, start_index+index+1) }
  end

  # Prints a summary detail row
  def self.summary_detail_row(listing, item_number)
    "#{(item_number).to_s.rjust(2)}. #{listing.item.summary_detail} #{fmt_col(5,listing.seller.name)} #{fmt_col(6,listing.seller.location)} #{fmt_col(7,listing.start_date)}"
  end

  # NOTE: possibly replace all this formatting code by changing #puts to use printf style formatting instead.

  # Standardizes column widths and justifications
  def self.fmt_col(col_num, str)
    case col_num
    when 1; "#{rfmt(str,  3)}"
    when 2; "#{lfmt(str, 34)}"
    when 3; "#{rfmt(str,  7)}"
    when 4; "#{rfmt(str,  8)}"
    when 5; "#{lfmt(str, 28)}"
    when 6; "#{lfmt(str, 32)}"
    when 7; "#{lfmt(str, 10)}"
    else
      "error"
    end
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
        if line_len > (MAX_LINE_LENGTH + 2)  # allow a word to extend over MAX_LINE_LENGTH a bit.
          new_string += "\n  #{self.fmt_detail_attr('')}"
          line_len = 0
        end
      end
      new_string += "#{word} "
    }
    new_string
  end

  ## PRIVATE METHODS
  private

  # Left justify string and pad or trim to size
  def self.lfmt(string, size)
    string.slice(0,size).ljust(size)
  end

  # Right justify string and pad or trim to size
  def self.rfmt(string, size)
    string.slice(0,size).rjust(size)
  end
end
