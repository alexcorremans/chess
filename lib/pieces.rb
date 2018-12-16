Dir["/piece/*"].each {|file| require file }

require 'forwardable'
class Pieces
  extend Forwardable
  def_delegator :@pieces, :each
  include Enumerable

  def initialize(pieces)
    @pieces = pieces
  end

  def get_pieces(type, colour)
    if type == 'all'
      find_all { |piece| piece.colour == colour }
    else
      find_all { |piece| piece.type == type && piece.colour == colour }
    end
  end

  def get_king(team)
    find { |piece| piece.type == 'king' && piece.colour == team }
  end

  def remove(piece)
    @pieces -= [piece]
  end

  def set_moved(moved_piece)
    @pieces = self.map do |piece|
      piece == moved_piece ? piece.set_moved : piece
    end
    return moved_piece.set_moved
  end
end