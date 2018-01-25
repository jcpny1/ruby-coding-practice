class Classifieds::Node

  @prev = nil
  @next = nil
  @data = nil

  def initialize(data)
    puts "NODE"
    @data = data
  end

  def data
    @data
  end

  def next
    @next
  end

  def next=(node)
    @next = node
  end

  def prev=(node)
    @prev = node
  end

end
