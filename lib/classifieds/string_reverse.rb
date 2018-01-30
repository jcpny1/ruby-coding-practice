class Classifieds::StringReverse

  def initialize
    original_string = "the dog ate my homeworks"

    puts "STRING REVERSE"
    puts 'Original:   ' + original_string
    puts 'Reversed:   ' + string_reverse(original_string)
    puts 'Reversed 2: ' + string_reverse_2(original_string)

    puts "WORD REVERSE"
    puts word_reverse(original_string)
    puts "WORD REVERSE 2"
    puts word_reverse_2(original_string)
    puts "WORD REVERSE 3"
    puts word_reverse_3(original_string)
  end

  def string_reverse(string)
    string.reverse
  end

  def string_reverse_2(string)
    new_string = ''
    string.each_char {|chr| new_string = chr + new_string}
    new_string
  end

  # reverse the characters in each word.
  def word_reverse(string)
    string.split.map{|w| string_reverse(w)}.join(' ')
  end

  # reverse the order of the words.
  def word_reverse_2(string)
    # string.split(' ').reverse.join(' ')
    word_array = string.split
    i = 0
    while i < word_array.length/2
      tmp = word_array[i]
      word_array[i] = word_array[word_array.length-i-1]
      word_array[word_array.length-i-1] = tmp
      i += 1
    end
    word_array.join(' ')
  end

  # reverse the order of the words and the characters in each word.
  def word_reverse_3(string)
    word_reverse(word_reverse_2(string))
  end

end
