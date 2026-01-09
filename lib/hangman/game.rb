module Hangman
  class Game
    SAVED_GAME_PATH = "./data/saved_game.json"

    attr_accessor :nr_rounds_left, :secret_word, :masked_word, :correctly_guessed_letters,
                  :incorrectly_guessed_letters, :incorrectly_guessed_words, :skip_save_prompt

    def initialize
      @nr_rounds_left = 8
      @secret_word = WordBank.new.secret_word
      @masked_word = "_" * secret_word.length
      @correctly_guessed_letters = []
      @incorrectly_guessed_letters = []
      @incorrectly_guessed_words = []
      @skip_save_prompt = false
    end

    def save_game
      f = File.new SAVED_GAME_PATH, "w+"
      data = JSON.dump({
                         secret_word: secret_word,
                         masked_word: masked_word,
                         correctly_guessed_letters: correctly_guessed_letters,
                         incorrectly_guessed_letters: incorrectly_guessed_letters,
                         incorrectly_guessed_words: incorrectly_guessed_words,
                         nr_rounds_left: nr_rounds_left
                       })
      f.write(data)
      f.close
      puts "Successfully written #{data} to disk."
    end

    def load_saved_game
      data = JSON.load(File.read(SAVED_GAME_PATH))
      self.secret_word = data["secret_word"]
      self.masked_word = data["masked_word"]
      self.correctly_guessed_letters = data["correctly_guessed_letters"]
      self.incorrectly_guessed_letters = data["incorrectly_guessed_letters"]
      self.incorrectly_guessed_words = data["incorrectly_guessed_words"]
      self.nr_rounds_left = data["nr_rounds_left"]
      puts "Successfully loaded #{data} from disk."
      self.skip_save_prompt = true
    end

    def single_letter_guess(guess)
      if secret_word.include?(guess)
        secret_word.chars.each_with_index do |letter, index|
          if letter == guess
            masked_word[index] = guess
            correctly_guessed_letters << guess unless correctly_guessed_letters.include?(guess)
          end
        end
      elsif !incorrectly_guessed_letters.include?(guess)
        incorrectly_guessed_letters << guess
      end
    end

    def whole_word_guess(guess)
      if secret_word == guess
        self.masked_word = secret_word.dup
      elsif !incorrectly_guessed_words.include?(guess)
        incorrectly_guessed_words << guess
      end
    end

    def start
      puts "Welcome to the game of hangman!"
      puts "Do you want to load previously saved game? (y/n)" if File.exist? SAVED_GAME_PATH
      load_saved_game if gets.chomp.downcase == "y"
      puts "A random secret word has been chosen."
      puts "Psst! The secret word is \"#{secret_word}\""
      make_guesses
    end

    def make_guesses
      while masked_word.chars.any? { |letter| letter == "_" } && nr_rounds_left > 0
        unless skip_save_prompt
          puts "Do you want to save the game? (y/n)"
          save_game if gets.chomp.downcase == "y"
        end
        self.skip_save_prompt = false
        puts "Nr. of missed guesses available to you: #{nr_rounds_left}"
        unless correctly_guessed_letters.empty?
          puts "Correctly guessed letters: #{correctly_guessed_letters.join(', ')}"
        end
        unless incorrectly_guessed_letters.empty?
          puts "Incorrectly guessed letters: #{incorrectly_guessed_letters.join(', ')}"
        end
        unless incorrectly_guessed_words.empty?
          puts "Incorrectly guessed words: #{incorrectly_guessed_words.join(', ')}"
        end
        puts "What will be your guess?"
        guess = gets.chomp.downcase

        old_masked_word = masked_word.dup

        case guess.length
        when 1
          single_letter_guess(guess)
        else
          whole_word_guess(guess)
        end

        puts "The masked word, following your guess, looks like this:"
        puts masked_word.chars.join(" ")

        self.nr_rounds_left = old_masked_word == masked_word ? nr_rounds_left - 1 : nr_rounds_left

        if masked_word == secret_word
          winner_message
          return
        end
      end
    end

    def winner_message
      puts "*****************************************"
      puts "Congratulations, you have won the game!"
      puts "*****************************************"
    end
  end
end
