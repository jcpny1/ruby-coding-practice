class Classifieds::TreeNode
  attr_reader :data, :parent, :left, :right

  def initialize(node, data)
    puts "NEW NODE"
    @data   = [data]
    @parent = node
    @left   = nil
    @right  = nil
  end

  def left=(node)
    @left = node
  end

  def print
    puts 'Node data: ' + @data[0]
  end

  def print_all
    print
    @left.print_all  if !left.nil?
    @right.print_all if !right.nil?
  end

  def right=(node)
    @right = node
  end
end
