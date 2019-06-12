
class Board
  attr_accessor :grid

  def initialize(grid=Array.new(3){Array.new(3)})
    @grid = grid
  end

  def [](pos)
    row,col = pos
    grid[row][col]
  end

  def []=(pos,mark)
    row, col = pos
    grid[row][col] = mark
  end

  def place_mark(pos,mark)
    empty?(pos) ? self[pos] = mark : "incorrect move, choose again."
  end

  def empty?(pos)
    self[pos] == nil ? true : false
  end

  def winner
      if (row || column || diagonal) == false
        return nil
      else
        row || column || diagonal
      end
  end

  def row
      self.grid.each do |row|
        if row.count(:X) == 3
          return :X
        elsif row.count(:O) == 3
          return :O
        end
      end
      false
  end

  def column
    self.grid.transpose.each do |row|
      if row.count(:X) == 3
        return :X
      elsif row.count(:O) == 3
        return :O
      end
    end
    false
  end

  def diagonal
    diagonal_coordinates = [[[0,0],[1,1],[2,2]],[[2,0],[1,1],[0,2]]]

    diagonal_coordinates.each do |diag|
      diag.map! do |ele|
        ele = self[ele]
      end
    end

    diagonal_coordinates.each do |set|
      if set.count(:O) == 3
        return :O
      elsif set.count(:X) == 3
        return :X
      end
    end
    false
  end


  def over?
    count = 0
    grid.each{|row| row.each{|ele| count += 1 if ele == :X}}
    grid.each{|row| row.each{|ele| count += 1 if ele == :O}}

    if count == 9
      return true
    elsif
      winner != nil
      return true
    end
    false
  end

end
