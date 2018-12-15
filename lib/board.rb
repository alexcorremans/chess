require_relative 'squares'
require_relative 'pieces'
require 'yaml'

class Board
  attr_reader :squares, :pieces, :last_move
  attr_accessor :messages

  def initialize(squares:, pieces:, last_move: nil, messages: [])
    @squares = squares
    @pieces = pieces
    @last_move = last_move
    @messages = messages
  end

  def display(team)
  end

  def get_pieces(type='all', team)
    pieces.get_pieces(type, team)
  end

  def get_position(piece)
    locate(piece)
  end

  def move_allowed?(move)
    # make sure all squares in the middle of the path are empty
    if move.path.size > 2
      return false unless path_empty?(move.path)
    end
    # check other rules
    if move.name.nil?
      return false unless normal_move_allowed?(move)
    else
      return false unless special_move_allowed?(move)
    end
    # make sure the move doesn't put the player's king in check
    if duplicate.update(move).check?(move.piece.colour)
      return false
    else
      return true
    end
  end

  def update(move)
    if move.name.nil?
      normal_move(move)
    else
      special_move(move)
    end
    update_last_move(move)
    return self
  end

  def check?(team)
    # one of the opposite player's pieces can capture the player's king
    king = get_king(team)
    opposite_team = switch_team(team)
    pieces = get_pieces(opposite_team)
    allowed_moves = allowed_moves(pieces, locate(king))
    !allowed_moves.empty?
  end

  def checkmate?(team)
    # king is in check
    # any move the player makes leaves the king in check
    # for all the pieces the player has, all the valid moves end with the king in check
    # for all the pieces the player has, get all the valid moves (something with iterating over can_move for each square)
    # for each valid move, look at the board: the king has to be in check still
  end

  def stalemate?(team)
  end

  private

  # methods related to board state

  def update_last_move(move)
    @last_move = move
  end

  def add_message(text)
    @messages << text
  end

  def duplicate
    YAML.load(YAML.dump(self))
  end

  def switch_team(team)
    team == 'black' ? 'white' : 'black'
  end

  # methods related to move checking and making moves

  def normal_move_allowed?(move)
    end_pos = move.path[-1]
    team = move.piece.colour
    if empty?(end_pos)
      return true 
    else
      return get_piece(end_pos).colour == team ? false : true
    end
  end

  def special_move_allowed?(move)
    end_pos = move.path[-1]
    team = move.piece.colour
    case move.name
    when 'two steps'
      return empty?(end_pos) ? true : false
    when 'capture'
      if empty?(end_pos) # en passant
        if last_move.name == 'two steps' && last_move.path[-1][0] == end_pos[0]
          return true
        else
          return false
        end
      elsif get_piece(end_pos).colour != team # normal capture
        return true
      else
        return false
      end
    when 'castling'
      king = move.piece
      return false if king.moved? || check?(team)
      case end_pos[0]
      when 2 # long castling
        corner = [0, end_pos[1]]
        middle_square = [3, end_pos[1]]
        return false if !empty?([1, end_pos[1]])
      when 6 # short castling
        corner = [7, end_pos[1]]
        middle_square = [5, end_pos[1]]
      end
      if !empty?(corner) && !get_piece(corner).moved? && king.can_move?(self, middle_square)
        return true
      else
        return false
      end
    end
  end

  def normal_move(move)
    start_pos = move.path[0]
    end_pos = move.path[-1]
    empty(start_pos)
    moved_piece = set_moved(move.piece)
    update_square(end_pos, moved_piece)
    add_message("You move your #{move.piece.type}.")
    capture(end_pos) if !empty?(end_pos)
  end

  def capture(location)
    captured = get_piece(location)
    remove(captured)
    text = "You captured a #{captured.type}!"
    add_message(text)
  end

  def special_move(move)
    start_pos = move.path[0]
    end_pos = move.path[-1]
    case move.name
    when 'two steps'
      normal_move(move)
    when 'capture'
      if empty?(end_pos) # en passant
        empty(start_pos)
        if end_pos[1] < start_pos[1]
          capture_pos = [end_pos[0], end_pos[1] + 1]
        else
          capture_pos = [end_pos[0], end_pos[1] - 1]
        end
        moved_piece = set_moved(move.piece)
        update_square(end_pos, moved_piece)
        add_message("Your pawn moves en-passant.")
        capture(capture_pos)        
      else # capture
        normal_move(move)
      end
    when 'castling'
      case end_pos[0]
      when 2 # long castling
        corner = [0, end_pos[1]]
        end_pos_rook = [3, end_pos[1]]
      when 6 # short castling
        corner = [7, end_pos[1]]
        end_pos_rook = [5, end_pos[1]]
      end
      # move the king
      empty(start_pos)
      moved_piece = set_moved(move.piece)
      update_square(end_pos, moved_piece)
      # move the rook
      rook = get_piece(corner)
      empty(corner)
      moved_rook = set_moved(rook)
      update_square(end_pos_rook, moved_rook)
      add_message("You move both your king and your rook in a castling move.")
    end
  end

  def create_move(piece, path, move_name=nil)
    Move.new(piece: piece, path: path, name: move_name)
  end

  # methods interacting with squares

  def update_square(location, piece)
    squares.update(location, piece)
  end

  def locate(piece)
    squares.locate(piece)    
  end

  def path_empty?(path)
    path = path[1..-2]
    path.all? do |coordinates|
      empty?(coordinates)
    end
  end

  def empty?(coordinates)
    squares.empty?(coordinates)
  end

  def empty(location)
    squares.empty(location)
  end

  def get_piece(location)
    squares.get_piece(location)
  end

  # methods interacting with pieces

  def remove(piece)
    pieces.remove(piece)
  end

  def set_moved(piece)
    pieces.set_moved(piece)
  end

  def allowed_moves(pieces, endpoint)
    pieces.select { |piece| piece.can_move?(self, endpoint) }
  end

  def get_king(team)
    pieces.detect { |piece| piece.type == 'king' && piece.colour == team }
  end  
end