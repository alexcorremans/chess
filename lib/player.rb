require_relative 'inputparser'

class Player
  attr_reader :team, :name
  
  def initialize(team:)
    @team = team
    @name = set_name
  end

  def play(board)
    choice = InputParser.get_input
    loop do
      if choice[:type] == 'other'
        return choice[:contents]
      elsif choice[:type] == 'move'
        try = make_move(board, choice[:contents])
        if try == 'success'
          return 'moved'
        else
          puts "Not a valid move. Please try again:"
          choice = get_input
        end
      end
    end
  end

  private

  def set_name
    puts "Please enter #{team.capitalize}'s player name:"
    name = gets.chomp.capitalize
    while name == ""
      puts "Please enter a name:"
      name = gets.chomp.capitalize
    end
    name
  end
  
  def make_move(board, move)
    board.move(team, move[piece_type:], move[endpoint:])
  end
end