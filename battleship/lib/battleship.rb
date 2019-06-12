#!/usr/bin/env ruby

require_relative "board"
require_relative "player"

class BattleshipGame
  attr_reader :board, :player

  def initialize(player=HumanPlayer.new, board=Board.new)
    @board = board
    @player = player
    @hit = false
    @hits = 0
  end


  def attack(pos)
    if board[pos] == :s
      @hit = true
    else
      @hit = false
    end

    board[pos] = :x
  end

  def hit?
    @hit
  end

  def count
    board.count
  end

  def game_over?
    board.won?
  end

  def valid_move?(move)
    return false if move == nil
    move.is_a?(Array) && move.length == 2
    # p move
  end

  def play_turn
    move = nil

    until valid_move?(move)
      status
      move = player.get_play
      p move
    end
    attack(move)
  end



  def status
    system("clear")
    if @hit
      @hits += 1
      puts "=============="
      puts "you hit a ship!"
      puts "=============="
    end
    puts "number of ships hit out of 10 : "
        puts "#{@hits}"
        puts '_______________'
        board.display
  end

  def play
    play_turn until game_over?
    gg
  end

  def gg
    puts "Congratulations you won!!"
  end


end

game = BattleshipGame.new
game.board.randomize
game.play
