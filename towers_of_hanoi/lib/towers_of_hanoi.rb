# Towers of Hanoi
#
# Write a Towers of Hanoi game:
# http://en.wikipedia.org/wiki/Towers_of_hanoi
#
# In a class `TowersOfHanoi`, keep a `towers` instance variable that is an array
# of three arrays. Each subarray should represent a tower. Each tower should
# store integers representing the size of its discs. Expose this instance
# variable with an `attr_reader`.
#
# You'll want a `#play` method. In a loop, prompt the user using puts. Ask what
# pile to select a disc from. The pile should be the index of a tower in your
# `@towers` array. Use gets
# (http://andreacfm.com/2011/06/11/learning-ruby-gets-and-chomp.html) to get an
# answer. Similarly, find out which pile the user wants to move the disc to.
# Next, you'll want to do different things depending on whether or not the move
# is valid. Finally, if they have succeeded in moving all of the discs to
# another pile, they win! The loop should end.
#
# You'll want a `TowersOfHanoi#render` method. Don't spend too much time on
# this, just get it playable.
#
# Think about what other helper methods you might want. Here's a list of all the
# instance methods I had in my TowersOfHanoi class:
# * initialize
# * play
# * render
# * won?
# * valid_move?(from_tower, to_tower)
# * move(from_tower, to_tower)
#
# Make sure that the game works in the console. There are also some specs to
# keep you on the right track:
#
# ```bash
# bundle exec rspec spec/towers_of_hanoi_spec.rb
# ```
#
# Make sure to run bundle install first! The specs assume you've implemented the
# methods named above.

#!/usr/bin/env ruby.

class TowersOfHanoi
  attr_reader :towers
  def initialize
    @towers = [[3,2,1],[],[]]
  end

  def move(from_tower, to_tower)
    if valid_move?(from_tower,to_tower)
        to_move = towers[from_tower].pop
      towers[to_tower] << to_move
    else
      puts "not a valid move"
    end
  end

  def valid_move?(from, to)
    size = towers[from].size
    if towers[from].empty?
      return false
    elsif towers[to].empty?
      return true
    elsif towers[from].last > towers[to].last
      return false
    end
    return true if (size > 0)
  end

  def won?
    towers[1..2].any?{|tower| tower.size == 3}
  end

  def render
    towers.each{|row| print row}
  end

  def play
    puts "-----------------"
    puts "Welcome to Towers of Hanoi"
    puts "The goal is to relocate one piece at a time to another peg until all three pieces are on another tower in ascending order"
    puts "Select two towers."
    puts "The first tower you choose is going to pull the topmost piece off (if there is one)"
    puts "The second tower you choose is going to place the piece from the first tower onto the new one (assuming you followed directions)"

    loop do
      if won?
        puts "GAME OVER" + "\n"
        puts "YOU WIN!"
        puts "play again?"
        puts "y or n"
        answer = gets.chomp
        if answer == "y"
          new_game = TowersOfHanoi.new
          new_game.play
        else
          puts "Thanks for playing"
          break
        end
      end
      puts "\n" + "-----------------------"
      puts "Select two numbers from 0-3"
      puts "-----------------------" + "\n"
      choice = gets.chomp.to_s.chars.map(&:to_i)
      from = choice[0]
      to = choice[1]
      if move(from, to)
        render
      end

    end

  end


end


game = TowersOfHanoi.new
game.play
