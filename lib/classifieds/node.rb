class Classifieds::Node
  attr_reader :data, :next

  @prev = nil
  @next = nil
  @data = nil

  def initialize(data)
    puts "NODE"
    @data = data
  end

  def next=(node)
    @next = node
  end

  def prev=(node)
    @prev = node
  end

end
