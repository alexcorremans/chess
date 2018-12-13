require_relative 'piece'

class WhitePawn < Piece
  def post_initialize
    @colour = 'white'
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
    [up]
  end

  def special_moves
    ['two steps', 'capture']
  end

  def get_special_move(a,b)
    start = square(a[0], a[1])
    endpoint = square(b[0], b[1])
    return nil unless endpoint.x.between?(0,7) && endpoint.y.between?(0,7)
    special_moves.each do |move_name|
      case move_name
      when 'two steps'
        next unless start.y == 1 &&
                endpoint.y == 3 &&
                endpoint.x == start.x
        path = [start, square(start.x, start.y + 1), endpoint]
      when 'capture'
        next unless (endpoint.x == start.x + 1 && endpoint.y == start.y + 1) ||
                    (endpoint.x == start.x - 1 && endpoint.y == start.y + 1)
        path = [start, endpoint]
      end
      return create_move(self, convert_path(path), move_name)
    end
    nil
  end
end