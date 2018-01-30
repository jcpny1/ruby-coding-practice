class Classifieds::BinaryTree
  def initialize
    puts "BINARY TREE"
    @head = nil
  end

  def add(data)
    if @head == nil
      @head = Classifieds::TreeNode.new(nil, data)
    else
      add_data(@head, data)
    end
  end

  def depth
    @head.nil? ? 0 : @head.depth
  end

  def print
    @head.print_all
  end

private

  def add_data(node, data)
    if data < node.data[0]
      if node.left == nil
        node.left = Classifieds::TreeNode.new(node, data)
puts 'left'
      else
        add_data(node.left, data)
      end
    elsif data > node.data[0]
      if node.right == nil
        node.right = Classifieds::TreeNode.new(node, data)
puts 'right'
      else
        add_data(node.right, data)
      end
    else
      node.data << data
    end
  end
end
