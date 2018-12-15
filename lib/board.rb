require_relative 'squares'
require_relative 'pieces'

class Board
  attr_reader :squares, :pieces, :last_move, :previous_state, :message

  def initialize(squares:, pieces:, last_move: nil, previous_state: nil, message: nil)
    @squares = squares
    @pieces = pieces
    @previous_state = previous_state
    @last_move = last_move
    @message = message
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
    # make sure all squares in the path are empty
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
    if update(move).check?(move.piece.colour)
      undo
      return false
    else
      return true
    end
  end

  def update(move)
    store_state
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

  def update_message(text)
    @message = text
  end

  def store_state
    @previous_state = self
  end

  def undo
    previous = previous_state
    @squares = previous.squares
    @pieces = previous.pieces
    @last_move = previous.last_move
    @message = previous.message
    @previous_state = previous.previous_state
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
    if !empty?(end_pos)
      captured = get_piece(end_pos)
      text = "You captured a #{captured.colour} #{captured.type}!"
      update_message(text)
      remove(captured)
    end
    set_moved(move.piece)
    update_square(end_pos, move.piece)
  end

  def special_move(move)
    set_moved(move.piece)
    update_square(end_pos, move.piece)
    # yada yada...
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
    pieces.select { |piece| piece.can_move?(board, endpoint) }
  end

  def get_king(team)
    pieces.detect { |piece| piece.type == 'king' && piece.colour == team }
  end  
end