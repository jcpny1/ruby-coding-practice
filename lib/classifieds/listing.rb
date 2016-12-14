class Classifieds::Listing  # describes a classified advertisement
  # A Listing has one item and one seller, along with listing-based attributes such as the listing start date

  @@all_listings = []

  def initialize(id, item, seller, start_date)
    @id = id
    @item = item
    @seller = seller
    @start_date = start_date
    Classifieds::Listing.all << self
  end

  # Empty list of created objects
  def self.clear_all
    Classifieds::Item.clear
    Classifieds::Seller.clear
    self.clear
  end

  # Prints a detail listing for a single item
  def print_detail(item_number)
    addon_details = {:Phone => @seller.phone, :'Listing #' => @id}
    puts '',
         self.summary_detail_row(item_number),
         @item.details_to_string(addon_details)
  end

  # Prints the specified summary listings for the specified item subclass
  def self.print_summary(item_class, start_index, end_index)
    puts "    #{item_class.summary_header} #{Classifieds::Seller.summary_header} #{lfmt('List Date', 10)}"
    all[start_index..end_index].each_with_index { |listing, index| puts listing.summary_detail_row(start_index+index+1) }
  end

  # Creates listings from summary web page
  def self.scrape_listings(item_class, results_url)
    results_url_file = open(results_url, :read_timeout=>10)
    results_doc = Nokogiri::HTML(results_url_file)
    item_class.scrape_results_page(results_url, results_url_file, results_doc)
  end

  # Returns detail attributes and values in detail_values hash
  def self.scrape_listing_details(item_class, detail_url, item_condition, detail_values)
    detail_doc = Nokogiri::HTML(open(detail_url, :read_timeout=>10))
    item_class.scrape_results_detail_page(detail_doc, item_condition, detail_values)
  end

  # Prints a summary detail row
  def summary_detail_row(item_number)
    "#{(item_number).to_s.rjust(2)}. #{@item.summary_detail} #{@seller.summary_detail} #{Classifieds::Listing.lfmt(@start_date, 10)}"
  end

  # Formats an array of strings according to an array of formats
  def self.fmt_cols(values, formats)
    result = ''
    values.each_with_index { |value, index| result << "#{fmt_col(value, formats[index][0], formats[index][1])} " }
    result
  end

  MAX_LINE_LENGTH = 100

  # Format a detail attribute
  def self.fmt_detail_attr(string, width)
    "#{lfmt(string, width)}"
  end

  # Format a detail item
  def self.format_detail(attr, attr_width, val)
    "#{fmt_detail_attr(attr, attr_width)}: #{fmt_detail_val(val, attr_width)}"
  end

  # Format a detail value (with wrap if necessary)
  def self.fmt_detail_val(string, wrap_indent)
    new_string = string.strip
    if new_string.size > MAX_LINE_LENGTH
      new_string = ''
      new_line = "\n  #{' '*wrap_indent}  "  # Indent size of Attribute display width.
      line_len = 0
      string.split(' ').each { |word|
        new_string << "#{word} "
        if (line_len += word.size + 1) > MAX_LINE_LENGTH
          new_string << new_line
          line_len = 0
        end
      }
    end
    new_string
  end

  ## PRIVATE METHODS
  private

  # Returns array of all listings
  def self.all
    @@all_listings
  end

  # Empty list of created objects
  def self.clear
    all.clear
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
