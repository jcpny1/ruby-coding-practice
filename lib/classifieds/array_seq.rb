class Classifieds::ArraySeq
  # find the longest sequence.

  ARRAY=[100, 4, 200, 1, 3, 2]

  def initialize
    puts 'ARRAY SEQ'
    puts "Original: #{ARRAY}"
    hash = {}
    ARRAY.each {|e| hash[e] = 1}  # load hash table
    max_seq = 0
    ARRAY.each do |e|
      counter = 1
      # count lower values
      left = e - 1
      while hash.has_key?(left)
        counter += 1
        left -= 1
      end
      # count upper values
      right = e + 1
      while hash.has_key?(right)
        counter += 1
        right += 1
      end
      max_seq = counter > max_seq ? counter : max_seq
    end
    puts max_seq
  end
end
