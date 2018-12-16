require_relative 'inputparser'

class Player
  attr_reader :team, :name
  
  def initialize(**opts)
    @team = opts[:team]
    @name = opts[:name] || set_name
  end

  def play(board)
    choice = get_input
    loop do
      case choice[:type]
      when 'other'
        return choice[:contents]
      when 'move'
        result = make_move(board, choice[:contents])
        if result == 'invalid'
          puts "Not a valid move. Please try again:"
          choice = get_input
        elsif result == 'again'
          puts "You didn't make a choice. Please try again:"
        else
          return result
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

  def get_input
    InputParser.get_input
  end

  def revert(coordinates)
    InputParser.revert(coordinates)
  end  
  
  def make_move(board, move)
    piece_type = move[:piece_type]
    endpoint = move[:endpoint]
    pieces = get_pieces(board, piece_type, team)
    return 'invalid' if pieces.empty?
    can_move = can_move(board, pieces, endpoint)
    if can_move.empty?
      return 'invalid'     
    elsif can_move.size > 1
      piece = which_piece(can_move) 
      return 'again' if piece.nil?
    else
      piece = can_move.pop
    end
    board = move_piece(piece, board, endpoint)
    return board
  end

  def get_pieces(board, piece_type, team)
    board.get_pieces(piece_type, team)
  end

  def can_move(board, pieces, endpoint)
    pieces.select { |piece| piece.can_move?(board, endpoint) }
  end

  def move_piece(piece, board, endpoint)
    piece.move(board, endpoint)
  end

  def which_piece(can_move)
    puts "More than one piece can make that move."
    can_move.each do |piece|
      coordinates = board.get_position(piece)
      pos = revert(coordinates)
      puts "Do you want to move the #{piece.type} that is currently at #{pos[0]}#{pos[1]}? Please answer (y/n)"
      reply = gets.chomp.downcase
      until reply == 'y' || reply == 'n'
        "Please type 'y' to indicate you want to move the piece above, or 'n' to go on to the next piece that can make the move."
        reply = gets.chomp.downcase
      end
      return piece if reply == 'y'
    end
    nil    
  end
end