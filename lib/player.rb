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
        new_board = make_move(board, choice[:contents])
        if new_board.nil?
          puts "Not a valid move. Please try again:"
          choice = get_input
        else
          return new_board
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
    piece_type = move[piece_type:]
    endpoint = move[endpoint:]
    
    pieces = get_pieces(piece_type, team)
    return nil if pieces.empty?
    
    can_move = can_move(pieces, endpoint)
    if can_move.empty?
      return nil      
    elsif can_move.size > 1
      piece = which_piece(can_move) 
    else
      piece = can_move.pop
    end
    
    board = move_piece(piece, board, endpoint)
    return board
  end

  def get_pieces(piece_type, team)
    board.get_pieces(piece_type, team)
  end


  def can_move(pieces, endpoint)
    pieces.select { |piece| piece.can_move?(board, endpoint) }
  end

  def move_piece(piece, board, endpoint)
    piece.move(board, endpoint)
  end

  def which_piece(can_move)
    # ask which of the pieces needs to move and return the correct piece
    # maybe offer an option to change your mind? 
  end
end