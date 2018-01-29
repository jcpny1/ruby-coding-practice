class Classifieds::Hash

  def initialize
    puts "HASH"
    @hash = {}
  end

  # Add data to hash.
  def add(key, data)
    node = Classifieds::ListNode.new(data)
    if @hash.has_key?(key)
      @hash[key] << node
    else
      @hash[key] = [node]
    end
  end

  def print
    puts "PRINT HASH"
    @hash.each do |key, array|
      array.each do |node|
        puts "#{key} #{node.data}"
      end
    end
  end
end
