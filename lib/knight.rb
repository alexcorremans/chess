require_relative 'piece'
require_relative 'square'

class Knight < Piece
  def try_path(a, b, direction)
    start = Square.new(x: a[0], y: a[1])
    path = [start]
    direction.each do |step|
      if start.x + step[0] == b[0] && start.y + step[1] == b[1]
        path << Square.new(x: b[0], y: b[1], parent: start)
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