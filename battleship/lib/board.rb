
class Board
  attr_reader :grid

  def initialize(default=Board.default_grid)
    @grid = default
  end

  def self.default_grid
    Array.new(10){Array.new(10)}
  end



  def randomize
    10.times do
      self.place_random_ship
    end
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    grid[row][col] = val
  end

  def count
    total = 0
    grid.each{|row| row.each{|ele| total +=1 if ele == :s}}
    total
  end

  VALUES = {
    nil => '  ',
    :s => '  ',
    :x => 'x '
  }

  def display
    columns = (0..9).to_a.join("  ")
    puts "   #{columns}"
    grid.each_with_index{|row,idx| row(row,idx)}
  end
  def row(row,idx)
    contents = row.map{|ele| VALUES[ele]}.join(' ')
    p "#{idx} #{contents}"
  end


  def empty?(*pos)
    pos = pos.flatten

    if pos.empty?
      if count == 0
        return true
      else
        return false
      end
    else
      if self.grid[pos[0]][pos[1]] == nil
        return true
      else
        return false
      end
    end
  end

  def full?
    self.grid.each do |row|
      row.each do |ele|
        return false if ele == nil
      end
    end
    true
  end

  def place_random_ship
    #collect all nil coordinates
    #sample nil coordinates

    if full?
      raise "The board is full!"
    else
      nil_coords = []
      self.grid.each_with_index do |row, idx|
        row.each_with_index do |ele, idx2|
          if ele == nil
            nil_coords << [idx,idx2]
          end
        end
      end
      random_ship_coordinate = nil_coords.sample
      self.grid[random_ship_coordinate[0]][random_ship_coordinate[1]] = :s
    end
  end


  def won?
    # self.grid.each do |row|
    #   row.each do |ele|
    #     return false if ele == :s
    #   end
    # end
    # true
    if count == 0
      return true
    end
    false
  end



end
