
class ComputerPlayer
  attr_reader :name, :board
  attr_accessor :mark

  def initialize(name)
    @name = name
  end

  def display(board)
    @board = board
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
    empty_spaces = []
    board.grid.each_with_index{|row, idx| row.each_with_index{|ele, idx2| empty_spaces << [idx,idx2] if (ele == nil)}}

    empty_spaces.each do |coord|
      board[coord] = :O
        if board.winner != nil
          return coord
        else
          board[coord] = nil
        end
    end
    empty_spaces.sample
  end



end
