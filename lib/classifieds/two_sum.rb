class Classifieds::TwoSum

  # Given an array of integers, find two numbers such that they add up to a specific target number.
  # The function twoSum should return indices of the two numbers such that they add up to the target, where index 1 must be less than index 2.
  # For example:
  #   Input: numbers={2, 7, 11, 15}, target=9
  #   Output: index1=0, index2=1

  def initialize
    puts "TWO SUM"
    @hash = {}
    @numbers=[]
  end

  def run
    @numbers=[2, 7, 11, 15]
    search1(26)
    search2(26)
  end

  # Add a number to the @numbers array.
  def add(num)
    @numbers << num
  end

  # Find the target sum in the @numbers array.
  def find(num)
    search1(num)
  end

  # Method 1 - input array may be unsorted.
  def search1(num)
    @numbers.each_with_index do |number, i|
      if @hash[number]
        puts "Indexes: #{@hash[number]}, #{i}"
        break
      else
        @hash[num - number] = i
      end
      puts 'loop'
    end
  end

  # Method 2 - input array is sorted.
  def search2(num)
    i = 0
    j = @numbers.length - 1

    while i < j
      case (@numbers[i] + @numbers[j]) <=> num
      when -1
        i += 1
      when 0
        puts "Indexes: #{i}, #{j}"
        return
      when 1
        j -= 1
      end
      puts 'loop'
    end
  end
end
