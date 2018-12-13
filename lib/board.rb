require_relative 'squares'
require_relative 'pieces'

class Board
  attr_reader :squares, :pieces

  def initialize(squares:, pieces:, last_move: nil)
    @squares = squares
    @pieces = pieces
    @last_move = last_move
  end

  def display(team)
  end

  def get_pieces(type='all', team)
    pieces.get_pieces(type, team)
  end

  def get_position(piece)
    locate(piece)
  end

  def can_move?(move)
    # true or false depending on the rules. 
    # if !special-move
      # normal behaviour
    # else
      # special_move_allowed?(piece, path, move_name)
    # rule 1: if path.size > 3: check if the squares in the middle are empty
    # other rules: castling, en passant, pawn two steps, pawn capture
    # note for castling: it's the king who initiates the move
  end

  def move(move)
    if move.name.nil?
      return normal_move(move)
    else
      return special_move(move)
    end
  end

  def check?(team)
    # one of the opposite player's pieces can capture the team's king
    king = get_king(team)
    # get opposite_team
    pieces = get_pieces(opposite_team)
    can_move = can_move(pieces, locate(king))
    !can_move.empty?
  end

  def check_mate?(team)
    # king is in check
    # any move the player makes leaves the king in check
    # for all the pieces the player has, all the valid moves end with the king in check
    # for all the pieces the player has, get all the valid moves (something with iterating over can_move for each square)
    # for each valid move, look at the board: the king has to be in check still
  end

  private

  def special_move(move)
    update_last_move(move)
  end

  def normal_move(move)
    start_pos = move.path[0]
    end_pos = move.path[-1]
    empty(start_pos)
    if !empty?(end_pos)
      captured = get_piece(end_pos)
      puts "You captured a #{captured.colour} #{captured.type}!"
      remove(captured)
      empty(end_pos)
    end
    add(end_pos, move.piece)
    update_last_move(move)
    return self
  end

  def add(location, piece)
    squares.add(location, piece)
  end

  def locate(piece)
    squares.locate(piece)
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

  def remove(piece)
    pieces.remove(piece)
  end

  def can_move(pieces, endpoint)
    pieces.select { |piece| piece.can_move?(board, endpoint) }
  end

  def get_king(team)
    pieces.detect { |piece| piece.type == 'king' && piece.team == team }
  end

  def update_last_move(move)
    @last_move = move
  end
end