require_relative 'squares'
require_relative 'pieces'

class Board
  attr_reader :squares, :pieces

  def initialize(squares:, pieces:)
    @squares = squares
    @pieces = pieces
  end

  def display(colour)
  end

  def move(type, colour, end_point)
    # check if dest is within the board
    # check if piece is on the board: has_piece?(type, colour)
    # then locate(piece, colour) - again several possibilities
    # if dest is at the same location, inform player
    # then get_path from piece(start, dest) for each piece
    # empty_path needed yes or no? only for queen, rook, bishop WOOHOO
    # destination full? that's a capture, need to let the player know
    # empty piece's position on the board
    # add piece to destination
    # castling, en passant, pawn two steps, pawn capture
  end

  def check?
  end

  def check_mate?
  end

  private

  def has_piece?(type, colour)
    get_pieces(type, colour).nil? ? true : false
  end

  def get_pieces(type, colour)
    pieces.get_pieces(type, colour)
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
end