
class HumanPlayer
  # attr_accessor :get_play
  def initialize(name="Balthazar")
    @name = name
  end

  def get_play
    puts "where would you like to attack, sir or madam?"
    puts "respond with 2 numbers representing coordinates"
    move = gets.chomp.to_s.chars.map(&:to_i)
  end

end
