fname = "./data/google-10000-english-no-swears.txt"

word_array = File.readlines(fname)
filtered_words = word_array.map(&:chomp).filter { |word| word.length >= 5 && word.length <= 12 }
secret_word = filtered_words.sample()
masked_word = "_" * secret_word.length

puts "A random secret word has been chosen:"
puts "Psst! The secret word is #{secret_word}"
puts masked_word.chars.join(" ")

puts "What will be your guess?"
guess = gets.chomp

def update_masked_word(secret_word, masked_word, guess)
  secret_word.chars.each_with_index do |letter, index| 
    masked_word[index] = guess if letter == guess
  end
end

if guess.length == 1
  update_masked_word(secret_word, masked_word, guess)
end
