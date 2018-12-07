require_relative 'piece'
require_relative 'square'

class BlackPawn < Piece
  def post_initialize
    @colour = 'black'
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
    [down]
  end
end

black_pawn = BlackPawn.new
puts black_pawn.colour
black_pawn.print_path([1,4],[1,5])
black_pawn.print_path([1,4],[1,3])
black_pawn.print_path([1,4],[1,2])
black_pawn.print_path([1,7],[1,6])
black_pawn.print_path([1,7],[1,5])