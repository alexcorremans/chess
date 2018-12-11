require_relative 'piece'

class King < Piece
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
    [up, right, down, left, diagonal_right_up, diagonal_right_down, diagonal_left_up, diagonal_left_down]
  end
end