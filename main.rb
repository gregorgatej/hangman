require "json"

SAVED_GAME_PATH = "./data/saved_game.json"

nr_rounds_left = 8

masked_word = "_" * secret_word.length
correctly_guessed_letters = []
incorrectly_guessed_letters = []
incorrectly_guessed_words = []

def save_game(
  secret_word,
  masked_word,
  correctly_guessed_letters,
  incorrectly_guessed_letters,
  incorrectly_guessed_words,
  nr_rounds_left
  )
  f = File.new SAVED_GAME_PATH, "w+"
  data = JSON.dump ({
  :secret_word => secret_word,
  :masked_word => masked_word,
  :correctly_guessed_letters => correctly_guessed_letters,
  :incorrectly_guessed_letters => incorrectly_guessed_letters,
  :incorrectly_guessed_words => incorrectly_guessed_words,
  :nr_rounds_left => nr_rounds_left
  })
  f.write(data)
  f.close
  puts "Successfully written #{data} to disk."
end

def load_saved_game(saved_game_path)
  JSON.load(File.read(saved_game_path))
end

puts "Welcome to the game of hangman!"
puts "Do you want to load previously saved game? (y/n)" if File.exist? SAVED_GAME_PATH
if gets.chomp.downcase == "y"
  data = load_saved_game(SAVED_GAME_PATH)
  secret_word = data["secret_word"]
  masked_word = data["masked_word"]
  correctly_guessed_letters = data["correctly_guessed_letters"]
  incorrectly_guessed_letters = data["incorrectly_guessed_letters"]
  incorrectly_guessed_words = data["incorrectly_guessed_words"]
  nr_rounds_left = data["nr_rounds_left"]
  puts "Successfully loaded #{data} from disk."
  skip_save_prompt = true
end
puts "A random secret word has been chosen."
puts "Psst! The secret word is \"#{secret_word}\""

def single_letter_guess(secret_word, masked_word, guess, correctly_guessed_letters, incorrectly_guessed_letters)
  masked_word = masked_word.dup
  if secret_word.include?(guess)
    secret_word.chars.each_with_index do |letter, index| 
      if letter == guess
        masked_word[index] = guess
        correctly_guessed_letters << guess if !correctly_guessed_letters.include?(guess)
      end
    end
  else
    incorrectly_guessed_letters << guess if !incorrectly_guessed_letters.include?(guess)
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
unless skip_save_prompt
  puts "Do you want to save the game? (y/n)"
  if gets.chomp.downcase == "y"
  save_game(
    secret_word,
    masked_word,
    correctly_guessed_letters,
    incorrectly_guessed_letters,
    incorrectly_guessed_words,
    nr_rounds_left
  )
  end
end  
  skip_save_prompt = false
  puts "Nr. of missed guesses available to you: #{nr_rounds_left}"
  puts "Correctly guessed letters: #{correctly_guessed_letters.join (", ")}" unless correctly_guessed_letters.empty?
  puts "Incorrectly guessed letters: #{incorrectly_guessed_letters.join (", ")}" unless incorrectly_guessed_letters.empty?
  puts "Incorrectly guessed words: #{incorrectly_guessed_words.join (", ")}" unless incorrectly_guessed_words.empty?
  puts "What will be your guess?"
  guess = gets.chomp.downcase

  old_masked_word = masked_word.dup

  case guess.length
  when 1
    masked_word = single_letter_guess(secret_word, masked_word, guess, correctly_guessed_letters, incorrectly_guessed_letters)
  else
    masked_word = whole_word_guess(secret_word, masked_word, guess, incorrectly_guessed_words)
  end

  puts "The masked word, following your guess, looks like this:"
  puts masked_word.chars.join(" ")
  nr_rounds_left = old_masked_word == masked_word ? nr_rounds_left -= 1 : nr_rounds_left

  if masked_word == secret_word
    puts "*****************************************"
    puts "Congratulations, you have won the game!"
    puts "*****************************************"
    return
  end
end
