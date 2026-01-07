fname = "./data/google-10000-english-no-swears.txt"

word_array = File.readlines(fname)
filtered_words = word_array.map(&:chomp).filter { |word| word.length >= 5 && word.length <= 12 }
secret_word = filtered_words.sample()
masked_word = "_" * secret_word.length
incorrectly_guessed_letters = []
incorrectly_guessed_words = []
nr_rounds_left = 8

puts "A random secret word has been chosen:"
puts "Psst! The secret word is \"#{secret_word}\""

def single_letter_guess(secret_word, masked_word, guess, incorrectly_guessed_letters)
  masked_word = masked_word.dup
  secret_word.chars.each_with_index do |letter, index| 
    if letter == guess
      masked_word[index] = guess
    elsif !incorrectly_guessed_letters.include?(guess)
      incorrectly_guessed_letters << guess
    end
  end
  masked_word
end

def whole_word_guess(secret_word, masked_word, guess, incorrectly_guessed_words)
  masked_word = masked_word.dup
  if secret_word == guess
    masked_word = secret_word.dup
  elsif !incorrectly_guessed_words.include?(guess)
    incorrectly_guessed_words << guess
  end
  masked_word
end

while masked_word.chars.any? { |letter| letter == "_" } && nr_rounds_left > 0
  puts "Nr. of missed guesses available to you: #{nr_rounds_left}"
  puts "Incorrectly guessed letters: #{incorrectly_guessed_letters.join (", ")}" unless incorrectly_guessed_letters.empty?
  puts "Incorrectly guessed words: #{incorrectly_guessed_words.join (", ")}" unless incorrectly_guessed_words.empty?
  puts "What will be your guess?"
  guess = gets.chomp.downcase

  old_masked_word = masked_word.dup

  case guess.length
  when 1
    masked_word = single_letter_guess(secret_word, masked_word, guess, incorrectly_guessed_letters)
  else
    masked_word = whole_word_guess(secret_word, masked_word, guess, incorrectly_guessed_words)
  end

  puts "The masked word, following your guess, looks like this:"
  puts masked_word.chars.join(" ")
  nr_rounds_left = old_masked_word == masked_word ? nr_rounds_left -= 1 : nr_rounds_left

  if masked_word == secret_word
    puts "Congratulations, you have won the game!"
    return
  end
end
