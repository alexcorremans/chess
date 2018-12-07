class Piece
  attr_reader :colour

  def initialize(colour='white')
    @colour = colour
    post_initialize
  end

  def get_path(a,b)
    directions.each do |direction|
      path = try_path(a,b,direction)
      return path if !path.nil?
    end
    nil
  end

  def print_path(a,b)
    if get_path(a,b).nil?
      puts "no path found" 
    else
      get_path(a,b).each do |square|
        puts "(#{square.x},#{square.y})"
      end
    end
  end

  def post_initialize
  end

  def try_path(a,b,direction)
    nil
  end

  def directions
    []
  end

  def up
    [0,1]
  end

  def right
    [1,0]
  end

  def down
    [0,-1]
  end

  def left
    [-1,0]
  end

  def diagonal_right_up
    [1,1]
  end

  def diagonal_right_down
    [1,-1]
  end

  def diagonal_left_up
    [-1,1]
  end

  def diagonal_left_down
    [-1,-1]
  end
end