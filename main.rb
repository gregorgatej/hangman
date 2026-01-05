fname = "./data/google-10000-english-no-swears.txt"

word_array = File.readlines(fname)
filtered_words = word_array.map(&:chomp).filter { |word| word.length >= 5 && word.length <= 12 }
random_word = filtered_words.sample()
