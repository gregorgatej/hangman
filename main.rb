fname = "./data/google-10000-english-no-swears.txt"

word_array = File.readlines(fname)
filtered_words = word_array.map(&:chomp).filter { |word| word.length >= 5 && word.length <= 12 }
secret_word = filtered_words.sample()
masked_word = "_" * secret_word.length

nr_rounds_left = 8

puts "A random secret word has been chosen:"
puts "Psst! The secret word is #{secret_word}"

def update_masked_word(secret_word, masked_word, guess)
  masked_word = masked_word.dup
  secret_word.chars.each_with_index do |letter, index| 
    masked_word[index] = guess if letter == guess
  end
  masked_word
end

def evaluate_whole_word_guess
  # TODO
end

while masked_word.chars.any? { |letter| letter == "_" } && nr_rounds_left > 0
  puts "Nr. of missed guesses available to you: #{nr_rounds_left}"
  puts "What will be your guess?"
  guess = gets.chomp.downcase

  old_masked_word = masked_word.dup

  case guess.length
  when 1
    masked_word = update_masked_word(secret_word, masked_word, guess)
  else
    evaluate_whole_word_guess
  end

  puts "The masked word, following your guess, looks like this:"
  puts masked_word.chars.join(" ")
  nr_rounds_left = old_masked_word == masked_word ? nr_rounds_left -= 1 : nr_rounds_left
end

