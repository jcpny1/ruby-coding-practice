class Classifieds::Hash

  def initialize
    puts "HASH"
    @hash = {}
  end

  # def insert_after(node, data)
  #   new_node = Classifieds::ListNode.new(data)
  #   tmp_next = node.next
  #   node.next = new_node
  #   new_node.next = tmp_next
  #   new_node.prev = node
  #   @tail = new_node if @tail == node
  # end

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
        puts node.data
      end
    end
  end
end
