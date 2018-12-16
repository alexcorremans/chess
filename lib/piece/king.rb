require_relative 'piece'

class King < Piece
  def try_path(a,b,direction)
    start_sq = square(a[0], a[1])
    path = [start_sq]
    current_square = start_sq.generate_child(direction)
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
    start_sq = square(a[0],a[1])
    end_sq = square(b[0],b[1])
    move_name = special_moves[0]
    case colour
    when 'white'
      return nil unless start_sq.x == 4 && start_sq.y == 0 && end_sq.y == 0  
    when 'black'
      return nil unless start_sq.x == 4 && start_sq.y == 7 && end_sq.y == 7
    end
    if end_sq.x == 6 # short castling
      path = [start_sq, square(start_sq.x + 1, start_sq.y), end_sq]   
    elsif end_sq.x == 2 # long castling
      path = [start_sq, square(start_sq.x - 1, start_sq.y), end_sq]
    else
      return nil
    end
    return create_move(self, convert_path(path), move_name)
  end
end