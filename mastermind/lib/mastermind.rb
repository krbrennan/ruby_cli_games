require 'byebug'
# require 'pry'

#my play method will know how many exact and near matches are guessed
#however the specs for exact and near are not all passing

#!/usr/bin/env ruby
class Code
  attr_reader :pegs

  def initialize(pegs)
    @pegs = pegs
    @game_over = false
  end

  PEGS ={
    "B" => :blue,
    "G" => :green,
    "O" => :orange,
    "P" => :purple,
    "R" => :red,
    "Y" => :yellow
  }

  def self.parse(string)
    #I can't get this method to pass specs and also ask for another guess
    #if the guess includes characters that arent included in PEGS
    #raise seems to return from the game.play method
    pegs = string.split('').map do |letter|
      if PEGS.has_key?(letter.upcase)
        PEGS[letter.upcase]
      else
        get_guess
        raise "parse error"
        # Game.get_guess
      end
    end
    Code.new(pegs)
  end

  def self.random
    pegs = []
    4.times do
      pegs << PEGS.values.sample
    end
    Code.new(pegs)
  end

  def [](i)
    pegs[i]
  end

  def exact_matches(other)
    count = 0
    idxs = []
    self.pegs.each_with_index{|peg,idx| count += 1 if self[idx] == other[idx]}
    count
  end

  def near_matches(other)
    #hashify self and other pegs, idx == k, color == value
    #go through self_hash, unless key has same value, increase count

    self_hash = Hash.new(0)
    other_hash = Hash.new(0)

    self.pegs.each_with_index{|peg,idx| self_hash[idx] = peg}
    other.pegs.each_with_index{|peg,idx| other_hash[idx] = peg}

    count = 0
    already_counted = []

    other_hash.each do |k,v|
      other_count = other_hash.values.count(v)
      self_count = self_hash.values.count(v)
      unless already_counted.include?(v)
        if other_count == self_count
          count += other_count
        elsif other_count > self_count
          count += self_count
        elsif other_count < self_count
          count += other_count
        end
      end
      already_counted << v
    end
    count - exact_matches(other)
    end

  def ==(other)
    return false if other.class != Code
    return true if self.pegs == other.pegs
    false
  end

end

class Game
  attr_reader :secret_code

  def initialize(secret_code=Code.random)
    @secret_code = secret_code
  end

  def get_guess

    begin
      Code.parse(gets.chomp)
    rescue
      puts "Incorrect input!, your options are: b , g , o , y , p"
      retry
    end
  end

  def display_matches(code)
    near = secret_code.near_matches(code)
    exact = secret_code.exact_matches(code)
    puts "#{near} matched nearly"
    puts "#{exact} matched exactly"
    # system('clear')
    # puts "\n"
    # # puts "__You Guessed:__#{@guess.pegs}____________________"
    # puts "__You Guessed:__#{@guess}____________________"
    #
    # puts "~~~~~~~~~~~~~~~~~~"
    # puts "#{near} matched nearly"
    # puts "#{exact} matched exactly"
    # puts "~~~~~~~~~~~~~~~~~~"
  end

  def game_over
    puts "============="
    puts "YOU GOT IT"
    puts "============="

    display_matches(@guess)
    @game_over = true
  end

  def play_turn
    p @secret_code
    puts "==============="
    puts "You have #{10 - @turns} turns left!"
    puts "==============="
    puts "guess the secret sequence, ex: bgbg"
    @guess = get_guess
    puts "\n"
    display_matches(@guess)
    puts "\n"
    # system("clear")

    if @guess == secret_code
      game_over
    end
  end

  def play
    system('clear')
    @turns = 0

    until (@turns == 10) || @game_over
      play_turn
      @turns += 1
    end

    puts "Game Over human"
    puts "\n The correct sequence was #{secret_code.pegs}"
    puts "\n"
  end

end

Game.new.play
