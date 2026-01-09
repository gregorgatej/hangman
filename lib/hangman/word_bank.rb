module Hangman
  class WordBank
    WORD_FILE_PATH = "./data/google-10000-english-no-swears.txt"

    attr_accessor :secret_word

    def initialize
      @secret_word = secret_word
    end

    def secret_word
      word_array = File.readlines(WORD_FILE_PATH)
      filtered_words = word_array.map(&:chomp).filter { |word| word.length >= 5 && word.length <= 12 }
      filtered_words.sample()
    end
  end
end
