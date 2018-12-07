require_relative 'piece'
require_relative 'square'

class King < Piece
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
    [up, right, down, left, diagonal_right_up, diagonal_right_down, diagonal_left_up, diagonal_left_down]
  end
end