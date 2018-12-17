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
          choice = get_input
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

  def choose_piece(piece_type, coordinates)
    InputParser.choose_piece(piece_type, coordinates)
  end
  
  def make_move(board, move)
    piece_type = move[:piece_type]
    end_pos = move[:end_pos]
    pieces = get_pieces(board, piece_type, team)
    return 'invalid' if pieces.empty?
    can_move = can_move(board, pieces, end_pos)
    if can_move.empty?
      return 'invalid'     
    elsif can_move.size > 1
      piece = which_piece(board, can_move) 
      return 'again' if piece.nil?
    else
      piece = can_move.pop
    end
    board = move_piece(piece, board, end_pos)
    return board
  end

  def get_pieces(board, piece_type, team)
    board.get_pieces(piece_type, team)
  end

  def get_position(board, piece)
    board.get_position(piece)
  end

  def can_move(board, pieces, end_pos)
    pieces.select { |piece| piece.can_move?(board, end_pos) }
  end

  def move_piece(piece, board, end_pos)
    piece.move(board, end_pos)
  end

  def which_piece(board, can_move)
    puts "More than one piece can make that move."
    can_move.each do |piece|
      coordinates = get_position(board, piece)
      reply = choose_piece(piece.type, coordinates)
      return piece if reply == 'y'
    end
    nil    
  end
end