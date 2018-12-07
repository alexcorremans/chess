%w{whitepawn blackpawn bishop rook knight queen king}.each { |l| require_relative l }
require 'forwardable'
class Pieces
  extend Forwardable
  def_delegator :@pieces, :each
  include Enumerable

  def initialize(pieces)
    @pieces = pieces
  end

  def get_pieces(type, colour)
    find_all { |piece| piece.type == type && piece.colour == colour }
  end
end