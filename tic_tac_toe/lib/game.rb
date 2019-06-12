#!/usr/bin/env ruby

require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

class Game
  attr_accessor :board, :current_player, :player_one, :player_two

  def initialize(player_one, player_two)
    @board = Board.new
    player_one.mark = :X
    player_two.mark = :O
    @player_one = player_one
    @player_two = player_two
    @current_player = player_one
  end

  def play_turn
    board.place_mark(current_player.get_move, current_player.mark)
    switch_players!
    system('clear')
    current_player.display(board)
  end

  def switch_players!
    if @current_player == @player_one
      @current_player = @player_two
    else
      @current_player = @player_one
    end
  end

  def display_win
    system('clear')
    puts "\n"
    puts "-------------------------"
    puts "GG, #{current_player.name} won!"
    puts "-------------------------"
    puts "\n"
  end

  def play
    current_player.display(board)
    play_turn until board.over?

    if won_game
      puts "#{won_game.name} wins!"
      puts "\n"
      won_game.display(board)
    end
  end

  def won_game
    return player_one if board.winner == player_one.mark
    return player_two if board.winner == player_two.mark
    nil
  end


end


human = HumanPlayer.new("Human")
computer = ComputerPlayer.new("Computer")

new_game = Game.new(human, computer)
new_game.play
