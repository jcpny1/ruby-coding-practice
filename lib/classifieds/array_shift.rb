class Classifieds::ArrayShift

  ARRAY=[1,2,3,4,5,6]

  def initialize
    puts 'ARRAY SHIFT'
    puts "Original: #{ARRAY}"
    puts "Shifted : #{array_shift(ARRAY,2)}"
    puts "Shifted2: #{array_shift_2([1,2,3,4,5,6],2)}"
    puts "Shifted3: #{array_shift_3(ARRAY,2)}"
  end

  # use Ruby
  def array_shift(array, shift)
    array.rotate(shift)
  end

  # brute force, one-at-at-time rotate
  def array_shift_2(array, shift)
    i = 0
    while i < shift
      j = 0
      tmp = array[0]
      while j < array.length - 1
        array[j] = array[j+1]
        j += 1
      end
      array[j] = tmp
      i += 1
    end
    array
  end

  # clever method in 1 space, N time.
  def array_shift_3(array, shift)
    part_1 = array[0..shift-1].reverse!
    part_2 = array[shift..array.length-1].reverse!
    (part_1 + part_2).reverse!
  end
end
