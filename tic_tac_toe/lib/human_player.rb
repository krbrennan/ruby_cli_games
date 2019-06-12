
class HumanPlayer
  attr_reader :name, :board
  attr_accessor :mark

  def initialize(name="Player_one")
    @name = name
  end

  def [](pos)
    row,col = pos
    grid[row][col]
  end

  def []=(pos,mark)
    row, col = pos
    grid[row][col] = mark
  end

  def get_move
    puts "\n"
    puts "please select a move in the form of a coordinate, such as 0,0"
    move = gets.chomp.split(',').map(&:to_i)
    if valid_move?(move)
      return move
    else
      get_move
    end
  end

  VALUES = {
    nil => '_',
    :X => 'X',
    :O => 'O'
  }
  def valid_move?(move)
    move.length == 2 && move[0].between?(0,2) && move[1].between?(0,2)
  end

  def display(board)
    header = (0..2).to_a.join('   ')
    puts "     #{header}"
    board.grid.each_with_index{|row,idx| display_row(row,idx)}
  end
  def display_row(row,idx)
    contents = row.map{|ele| VALUES[ele]}.join(' | ')
    puts "#{idx}    #{contents}  "
  end


end
