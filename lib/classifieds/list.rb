class Classifieds::List

  def initialize
    puts "LIST"
    @head = nil
    @tail = nil
  end

  def insert_after(node, data)
    new_node = Classifieds::Node.new(data)
    tmp_next = node.next
    node.next = new_node
    new_node.next = tmp_next
    new_node.prev = node
    @tail = new_node if @tail == node
  end

  # Append data to list tail.
  # Return new node.
  def push(data)
    node = Classifieds::Node.new(data)
    if @head.nil?
      @head = node
      @tail = node
    else
      @tail.next = node
      node.prev = @tail
      @tail = node
    end
    node
  end

  def print
    puts "PRINT LIST"
    cur_node = @head
    while !cur_node.nil?
      puts cur_node.data
      cur_node = cur_node.next
    end
  end

end
