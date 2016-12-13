class Item
  # .Item describes the thing in a listing that is for sale
  # It is expected to be subclassed based on the type of item for sale (e.g., vehicle, clothing, furniture, etc.)
  # To improve response time, an item's detail_values are only loaded on demand (from the detail url)

  @@all_items = []

  def initialize(title, price, condition, detail_url)
    @title = title
    @price = price
    @detail_url = detail_url
    @condition = condition
    @detail_values = {}
    Item.all << self
  end

  # Empty list of created objects
  def self.clear
    all.clear
  end

  COLUMN_SEPARATION = 5

  # Return the detail rows
  def details_to_string(addon_details)
    Scraper.listing_details(self.class, @detail_url, @condition, @detail_values) if @detail_values.empty?

    detail_values_array = @detail_values.to_a
    addon_details.delete(:Phone) if detail_phone  # do not use seller phone if item details has a phone.
    detail_values_array += addon_details.to_a

    offset = detail_values_array.size / 2 # prepare for two column output.
    mod2 = detail_values_array.size % 2   # and account for an odd number of details.
    col1_ljust = max_col1_width(detail_values_array, offset+mod2) + COLUMN_SEPARATION
    result = ''

    (0...offset+mod2).each { |index|
      # column 1
      attr = detail_values_array[index][0].to_s
      val = detail_values_array[index][1]
      result += "  #{Listing.format_detail(attr, attr_width(1), val).ljust(col1_ljust)}"

      # column 2
      if 'Description' == attr.to_s  # Have Description be on its own line.
        result += "\n"
      elsif (index + offset) < detail_values_array.size
        attr = detail_values_array[index+offset][0].to_s
        val = detail_values_array[index+offset][1]
        result += "#{Listing.format_detail(attr, attr_width(2), val)}\n"
      end
    }
    result
  end

  def detail_phone
    @detail_values[:Phone]
  end

  ## PRIVATE METHODS
  private

  # Find width of widest col1 data
  def max_col1_width(detail_values_array, end_val)
    max_width = 0
    (0...end_val).each { |index|
      attr = detail_values_array[index][0].to_s
      next if 'Description' == attr  # Description spans all cols, so don't count its width.
      val = detail_values_array[index][1]
      detail_width = Listing.format_detail(attr, attr_width(1), val).size
      max_width = detail_width if detail_width > max_width
    }
    max_width
  end

  # Return array of listings of given item_class
  def self.all
    @@all_items
  end
end
