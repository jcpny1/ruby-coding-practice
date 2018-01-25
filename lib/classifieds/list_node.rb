class Classifieds::ListNode
  attr_reader :next, :prev, :data

  @next = nil
  @prev = nil

  def initialize(data)
    puts "NEW NODE"
    @data = data
  end

  def next=(node)
    @next = node
  end

  def prev=(node)
    @prev = node
  end
end
