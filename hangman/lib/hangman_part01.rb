

class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(players)
    @guesser = players[:guesser]
    @referee = players[:referee]
    @letters_guessed = []
    @remaining_guesses = 10
  end

  def play
    system('clear')
    setup

    while @remaining_guesses >= 0
      take_turn
      if won?
        puts "Great jon, you guessed the word #{@referee.secret_word}"
        break
      end
      @remaining_guesses -= 1
    end
    system('clear')
    puts "\n"
    puts "\n"
    puts "=--=--=--=--=--=--=--=--="
    puts "GAME OVER, the secret word was:"
    puts "#{@referee.secret_word}"
    puts "=--=--=--=--=--=--=--=--="
    puts "\n"
    puts "\n"
  end


  def won?
    return true if @board.join('') == @referee.secret_word
    false
  end

  def setup
    length = referee.pick_secret_word
    guesser.register_secret_length(length)
    @board = [nil] * length
  end

  def take_turn
    puts "#{@letters_guessed}" unless @remaining_guesses == 10
    guess = @guesser.guess(@board)
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

  attr_reader :make_guess

  def initialize(dictionary)
    @dictionary = dictionary
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    return @secret_word.length
  end

  def register_secret_length(length)
    @length = length
  end

  def guess(guess)
    alphabet = *('a'..'z')
    alphabet.sample
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
    # p guess
    # p idxs
  end

end

if __FILE__ == $PROGRAM_NAME

  # guesser = ComputerPlayer.player_with_dict_file("dictionary.txt")
  referee = ComputerPlayer.player_with_dict_file("dictionary.txt")
  guesser = HumanPlayer.new

  Hangman.new({guesser:guesser, referee:referee}).play
end
