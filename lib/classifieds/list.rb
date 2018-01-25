class Classifieds::List

  @@head = nil
  @@tail = nil

  def initialize
    puts "LIST"
    @next = nil
    @prev = nil
  end

  def push(data)
    node = Classifieds::Node.new(data)

    if @@head.nil?
      @@head = node
      @@tail = node
    else
      @@tail.next = node
      node.prev = @@tail
      @@tail = node
    end
  end

  def print
    puts "PRINT LIST"
    cur_node = @@head
    while !cur_node.nil?
      puts cur_node.data
      cur_node = cur_node.next
    end
  end

end
