class Classifieds::TwoSum

  # Given an array of integers, find two numbers such that they add up to a specific target number.
  # The function twoSum should return indices of the two numbers such that they add up to the target, where index 1 must be less than index 2.
  # For example:
  #   Input: numbers={2, 7, 11, 15}, target=9
  #   Output: index1=0, index2=1


  def initialize
    puts "TWO SUM"

    numbers=[2, 7, 11, 15]
    target = 26
    hash = {}

    # Method 1 - input array may be unsorted.
    numbers.each_with_index do |number, i|
      if hash[number]
        puts "Indexes: #{hash[number]}, #{i}"
        break
      else
        hash[target - number] = i
      end
      puts 'loop'
    end

    # Method 2 - input array is sorted.
    i = 0
    j = numbers.length - 1

    while i < j
      case (numbers[i] + numbers[j]) <=> target
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
