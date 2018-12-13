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

  def special_moves
    ['castling']
  end

  def get_special_move(a,b)
    start = square(a[0],a[1])
    endpoint = square(b[0],b[1])
    move_name = special_moves[0]
    case colour
    when 'white'
      return nil unless start.x == 4 && start.y == 0 && endpoint.y == 0  
    when 'black'
      return nil unless start.x == 4 && start.y == 7 && endpoint.y == 7
    end
    if endpoint.x == 6 # short castling
      path = [start, square(start.x + 1, start.y), endpoint]   
    elsif endpoint.x == 2 # long castling
      path = [start, square(start.x - 1, start.y), endpoint]
    else
      return nil
    end
    return create_move(self, convert_path(path), move_name)
  end
end