module Directions
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