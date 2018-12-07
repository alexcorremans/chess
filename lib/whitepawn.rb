require_relative 'piece'
require_relative 'square'

class WhitePawn < Piece
  def post_initialize
    @colour = 'white'
  end

  def try_path(a,b,direction)
    start = Square.new(x: a[0], y: a[1])
    path = [start]
    if start.x + direction[0] == b[0] && start.y + direction[1] == b[1]
      path << Square.new(x: b[0], y: b[1], parent: start)
      return path
    end
    nil
  end

  def directions
    [up]
  end
end


white_pawn = WhitePawn.new
puts white_pawn.colour
white_pawn.print_path([1,2],[1,4])
white_pawn.print_path([1,1],[1,3])
white_pawn.print_path([1,2],[1,3])
white_pawn.print_path([1,0],[1,1])