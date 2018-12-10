require_relative 'piece'
require_relative 'square'

class BlackPawn < Piece
  def post_initialize
    @colour = 'black'
    @type = 'pawn'
  end

  def try_path(a,b,direction)
    start = square(a[0], a[1])
    path = [start]
    if start.x + direction[0] == b[0] && start.y + direction[1] == b[1]
      path << square(b[0], b[1], start)
      return path
    end
    nil
  end

  def directions
    [down]
  end
end