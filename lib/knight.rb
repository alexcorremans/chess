require_relative 'piece'
require_relative 'square'

class Knight < Piece
  def try_path(a, b, direction)
    start = square(a[0], a[1])
    path = [start]
    direction.each do |step|
      current_square = start.generate_child(step)
=begin
      if current_square.x == b[0] && current_square.y == b[1]
        path << current_square
        return path
      end
=end
      if start.x + step[0] == b[0] && start.y + step[1] == b[1]
        path << square(b[0], b[1], start)
        return path
      end
    end
    nil
  end

  def directions
    [l_shaped]
  end
  
  def l_shaped
    [[-2,-1],[-2,1],[-1,-2],[-1,2],[1,-2],[1,2],[2,-1],[2,1]]
  end
end