fname = "./data/google-10000-english-no-swears.txt"

word_array = File.readlines(fname)
filtered_words = word_array.map(&:chomp).filter { |word| word.length >= 5 && word.length <= 12 }
random_word = filtered_words.sample()
masked_word = "_" * random_word.length

masked_word_representation = Array.new(masked_word.length, "_").join(" ")
puts "A random word has been chosen:"
puts "Psst! The random word is #{random_word}"
puts masked_word_representation

