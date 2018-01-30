class Classifieds::ArrayDup
  # find the duplicate values.

  ARRAY=[4, 0, 1, 2, 16, 4, 12, 13, 7, 14, 15, 5, 7, 6, 7, 8, 9, 10]

  def initialize
    puts 'ARRAY DUP'
    puts "Original: #{ARRAY}"
    hash = {}
    found_dup = {}
    ARRAY.each do |e|
      if hash.has_key?(e)
        if !found_dup.has_key?(e)
          puts "Dup: #{e}"
          found_dup[e] = 1
        end
      else
        hash[e] = 1
      end
    end
  end
end
