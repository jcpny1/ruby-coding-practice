class Classifieds::Item  # describes the thing in a listing that is for sale
  # It is expected to be subclassed based on the type of item for sale (e.g., vehicle, clothing, furniture, etc.)
  # To improve response time, an item's detail_values are only loaded on demand (from the detail url)

  def initialize(title, price, condition, detail_url)
    @title = title
    @price = price
    @detail_url = detail_url
    @condition = condition
    @detail_values = {}
  end

  # Empty list of created objects
  def self.clear
    # all.clear  # not used, for now.
  end

  COLUMN_SEPARATION = 5

  # Return an item's detail data formatted for display
  def details_to_string(addon_details)
    Classifieds::Listing.scrape_listing_details(self.class, @detail_url, @condition, @detail_values) if @detail_values.empty?

    # Setup attribute/value details array
    detail_values_array = @detail_values.to_a
    addon_details.delete(:Phone) if detail_phone?  # do not addon phone if item details has a phone.
    detail_values_array.concat(addon_details.to_a)
    col2_offset = ((detail_values_array.size-1) / 2) + ((detail_values_array.size-1) % 2) # remove 1 from array size for description. It will get its own row.

    col_attr_width = []
    col_width = []

    # Calculate column 1 widths
    widths = max_col_widths(detail_values_array, 0, col2_offset)  # [max_attr_width, max_val_width, max_column_width]
    col_attr_width[0] = widths[0]
    col_width[0] = [widths[2], Classifieds::Item.col_width_limit(1)].min  # limit col width to max col width
    col_width[0] += COLUMN_SEPARATION

    # Calculate column 2 widths
    widths = max_col_widths(detail_values_array, col2_offset+1, detail_values_array.size)  # [max_attr_width, max_val_width, max_column_width]
    col_attr_width[1] = widths[0]
    col_width[1] = [widths[2], Classifieds::Item.col_width_limit(2)].min  # limit col width to max col width

    # Description value spans all columns.
    attribute = detail_values_array[0][0].to_s
    value = detail_values_array[0][1]
    result = "  #{Classifieds::Listing.format_detail(attribute, col_attr_width[0], value)}\n"

    # Then display remaining details in two column format.
    (1..col2_offset).each { |index|
      result << "  #{Classifieds::Item.format_pair(detail_values_array, index,             col_attr_width[0], col_width[0])}"
      next if (index+col2_offset) == detail_values_array.size  # when odd number of details.
      result << "  #{Classifieds::Item.format_pair(detail_values_array, index+col2_offset, col_attr_width[1], col_width[1])}\n"
    }
    result
  end

  ## PRIVATE METHODS
  private

  # Return attribute field width for given column
  def self.col_width_limit(col)
    [40, 40][col-1]
  end

  # Do the details contain a phone entry?
  def detail_phone?
    @detail_values[:Phone] ? true : false
  end

  # Formats an attribute/value pair for printing
  def self.format_pair(array, index, attr_width, col_width)
    attribute = array[index][0].to_s
    value = array[index][1]
    Classifieds::Listing.format_detail(attribute, attr_width, value).slice(0,col_width).ljust(col_width)
  end

  # Find widths of widest column data
  # Returns [max_attr_width, max_val_width, max_column_width]
  def max_col_widths(detail_values_array, start_index, end_index)
    max_attr_width = 0
    max_val_width = 0
    (start_index...end_index).each { |index|
      attribute = detail_values_array[index][0].to_s
      width = Classifieds::Listing.format_detail_attr(attribute, 0).size
      max_attr_width = width if width > max_attr_width
      next if 'Description' == attribute  # Description spans all cols, so don't consider its value width.
      value = detail_values_array[index][1]
      width = Classifieds::Listing.format_detail_val(value, 0).size
      max_val_width = width if width > max_val_width
    }
    [max_attr_width, max_val_width, max_attr_width + max_val_width + ': '.size]
  end
end
