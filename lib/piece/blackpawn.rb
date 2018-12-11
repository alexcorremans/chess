require_relative 'piece'

class BlackPawn < Piece
  def post_initialize
    @colour = 'black'
    @type = 'pawn'
  end

  def try_path(a,b,direction)
    start = square(a[0], a[1])
    path = [start]
    current_square = start.generate_child(direction)
    return nil if current_square.nil?
    if current_square.x == b[0] && current_square.y == b[1]
      path << current_square
      return convert_path(path)
    end
  end

  def directions
    [down]
  end
end