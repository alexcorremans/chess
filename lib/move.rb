class Move
  attr_reader :piece, :path, :name

  def initialize(piece:, path:, name: nil)
    @piece = piece
    @path = path
    @name = name
  end
end