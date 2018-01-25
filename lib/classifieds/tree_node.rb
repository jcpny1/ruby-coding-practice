class Classifieds::ListNode
  attr_reader :parent, :left, :right, :data

  @parent = nil
  @left   = nil
  @right  = nil

  def initialize(data)
    puts "NEW NODE"
    @data = data
  end

  def parent=(node)
    @parent = node
  end

  def left=(node)
    @left = node
  end

  def right=(node)
    @right = node
  end
end
