
class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(players)
    @guesser = players[:guesser]
    @referee = players[:referee]
    @letters_guessed = []
    @remaining_guesses = 14
  end

  def play
    system('clear')
    setup

    while @remaining_guesses >= 0
      take_turn
      if won?
        if @referee.class == ComputerPlayer
          puts "Great job program of mine, you guessed the word #{@referee.secret_word}"
          break
        else
          puts "\n"
          puts "Great job me! I guessed the word:"
          puts "\n"
          puts "~~~~~~~~#{@board.join('')}~~~~~~~~~"
          puts "\n"
          return
        end
      end
      @remaining_guesses -= 1
    end
    if @referee.class == ComputerPlayer
      system('clear')
      puts "\n"
      puts "\n"
      puts "=--=--=--=--=--=--=--=--="
      puts "GAME OVER, NICE JOB! the secret word was:"
      puts "#{@referee.secret_word}"
      puts "=--=--=--=--=--=--=--=--="
      puts "\n"
      puts "\n"
    else
      system('clear')
      puts "\n"
      puts "\n"
      puts "=--=--=--=--=--=--=--=--="
      puts "GAME OVER! the secret word was:"
      puts "something I couldn't guess! :["
      puts "=--=--=--=--=--=--=--=--="
      puts "\n"
      puts "\n"
    end
  end


  def won?
    return true if !@board.include?(nil)
    false
  end

  def setup
    length = referee.pick_secret_word
    guesser.register_secret_length(length)
    @board = [nil] * length
  end

  def take_turn
    puts "#{@letters_guessed}" unless @remaining_guesses == 14

    if @guesser.guess(@board) == nil
      @remaining_guesses = 0
    else
      guess = @guesser.guess(@board)
    end

    indexes = @referee.check_guess(guess)
    update_board(guess,indexes)
    @letters_guessed << guess
    @guesser.handle_response(guess,indexes) unless @remaining_guesses == 0
  end

  def update_board(guess, idx)
    idx.each{|index| @board[index] = guess}
  end

end
#############################################
#############################################
#############################################
#############################################
#############################################
#############################################
#############################################
class HumanPlayer

  def check_guess(guess)
    puts "Is #{guess} at any index(s)?"
    idx = []
    gets.chomp.to_s.chars.map(&:to_i)
    # if !response.between?(0,10)
    #   return idx
    # else
    #   idx << response
    # end
    # idx
  end

  def pick_secret_word
    puts "How long is your word?"
    gets.chomp.to_i
  end

  def register_secret_length(length)
    @length = length
  end

  def guess(board)
    board = board.map do |ele|
      if ele == nil
        ele = "_"
      else
        ele = ele
      end
    end
    puts "\n"
    puts "#{board.join(' ')}"
    puts "\n"
    puts "Guess a letter"
    letter = gets.chomp
  end

  def handle_response(guess,idxs)
    if idxs.empty?
      puts "\n"
      puts "========================="
      puts "Your guess was found nowhere on the board"
      puts "========================="
      puts "\n"
    else
      puts "\n"
      puts "========================="
      puts "Your guess #{guess} was found at index #{idxs}"
      puts "========================="
      puts "\n"
    end

  end

end
#############################################
#############################################
#############################################
#############################################
#############################################
#############################################
#############################################
class ComputerPlayer
  attr_reader :secret_word

  def self.player_with_dict_file(dict_file_name)
    ComputerPlayer.new(File.readlines(dict_file_name).map(&:chomp))
  end

  attr_reader :make_guess, :candidate_words

  def initialize(dictionary)
    @dictionary = dictionary
    @guessed_letters = []
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    return @secret_word.length
  end

  def register_secret_length(length)
    # @length = length
    @candidate_words = @dictionary.select{|word| word.length == length}
  end

  def guess(board)
    # need handle input if no candidate_words match letter idxs
    #candidate_words should take input and narrow down UNLESS input doesn't help narrow down
    # if new input doesn't narrow down candidate_words, puts "sorry I don't know that word" and break

    # this line below will pass if there are no candidate_words
    # p 'emptytytyty' if @candidate_words.empty?
    if @candidate_words.empty?
      return nil
    end

    letter_hash = Hash.new(0)

    @candidate_words.each do |word|
      word.chars.each do |letter|
        letter_hash[letter] += 1
      end
    end

    board.each do |ele|
      if letter_hash.has_key?(ele)
        letter_hash.delete(ele)
      end
    end

    letter_hash.sort_by{|k,v| v}.reverse[0][0]

    # if letter_hash.empty?
    #   p "kashdkjgadfkehhdh"
    # else
    #   letter_hash.sort_by{|k,v| v}.reverse[0][0]
    # end
  end

  def check_guess(guess)
    #is this the right place to raise an error and ask for
    #another input if the guess isn't a letter?
    #what if the user guesses the word or more than 1 letter?
    alphabet = *('a'..'z')
    if !alphabet.include?(guess)
      puts "not a valid guess"
    end
    idxs = []

    @secret_word.chars.each_with_index{|lett,idx| idxs << idx if lett == guess}
    return idxs

  end

  def handle_response(guess,idxs)
    #handle input that dones't narrow down candidate_words here

    if idxs.empty?
      @candidate_words = @candidate_words.select do |word|
        if !word.include?(guess)
          word
        end
      end

      return @candidate_words
    end


    @candidate_words = @candidate_words.select do |word|
      idxs.all? do |idx|
        word[idx] == guess && word.count(word[idx]) <= idxs.size
      end
    end
    @candidate_words
  end

end

if __FILE__ == $PROGRAM_NAME

  puts "Would you like to guess the word or have the computer guess your word?"
  puts "Put \n'me'\n if you would like to hold the word or \n'comp'\n if you would like to guess the computer's word"

  response = gets.chomp

  if response == "me"
    referee = HumanPlayer.new
    guesser = ComputerPlayer.player_with_dict_file("dictionary.txt")
    Hangman.new({guesser:guesser,referee:referee}).play
  else
    guesser = HumanPlayer.new
    referee = ComputerPlayer.player_with_dict_file("dictionary.txt")
    Hangman.new({guesser:guesser,referee:referee}).play
  end
end
