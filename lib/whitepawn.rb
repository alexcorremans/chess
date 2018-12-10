require_relative 'piece'
require_relative 'square'

class WhitePawn < Piece
  def post_initialize
    @colour = 'white'
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
    [up]
  end
end

=begin
white_pawn = WhitePawn.new
puts white_pawn.colour
p white_pawn.type
white_pawn.print_path([1,2],[1,4])
white_pawn.print_path([1,1],[1,3])
white_pawn.print_path([1,2],[1,3])
white_pawn.print_path([1,0],[1,1])
=end