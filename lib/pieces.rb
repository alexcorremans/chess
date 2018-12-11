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
end