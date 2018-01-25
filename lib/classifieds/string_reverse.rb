class Classifieds::StringReverse

  def initialize
    original_string = "The dog ate my homework."

    puts "STRING REVERSE"
    puts 'Original: ' + original_string
    puts 'Reversed: ' + string_reverse(original_string)

    puts "WORD REVERSE"
    puts word_reverse(original_string)
  end

  # def string_reverse(string)
  #   string.reverse
  # end
  #
  def string_reverse(string)
    new_string = ''
    string.each_char { |chr| new_string = chr + new_string  }
    new_string
  end

  def word_reverse(string)
    string.split(' ').map{|w| string_reverse(w)}.join(' ')
  end

end
