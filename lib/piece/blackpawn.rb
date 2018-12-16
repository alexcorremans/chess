require_relative 'piece'

class BlackPawn < Piece
  def post_initialize
    @colour = 'black'
    @type = 'pawn'
  end

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
    [down]
  end

  def special_moves
    ['two steps', 'capture']
  end

  def get_special_move(a,b)
    start_sq = square(a[0], a[1])
    end_sq = square(b[0], b[1])
    return nil unless end_sq.x.between?(0,7) && end_sq.y.between?(0,7)
    special_moves.each do |move_name|
      case move_name
      when 'two steps'
        next unless start_sq.y == 6 &&
                end_sq.y == 4 &&
                end_sq.x == start_sq.x
        path = [start_sq, square(start_sq.x, start_sq.y - 1), end_sq]
      when 'capture'
        next unless (end_sq.x == start_sq.x + 1 && end_sq.y == start_sq.y - 1) ||
                    (end_sq.x == start_sq.x - 1 && end_sq.y == start_sq.y - 1)
        path = [start_sq, end_sq]
      end
      return create_move(self, convert_path(path), move_name)
    end
    nil
  end
end