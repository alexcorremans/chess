require_relative 'piece'

class Knight < Piece
  def try_path(a, b, direction)
    start = square(a[0], a[1])
    path = [start]
    direction.each do |step|
      current_square = start.generate_child(step)
      next if current_square.nil?
      if current_square.x == b[0] && current_square.y == b[1]
        path << current_square
        return convert_path(path)
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