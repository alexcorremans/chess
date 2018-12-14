class Square
  attr_reader :x, :y, :contents, :child, :parent

  def initialize(x:, y:, contents: nil, child: nil, parent: nil)
    @x = x
    @y = y
    @contents = contents
    @child = child
    @parent = parent
  end

  def coordinates
    [x,y]
  end

  def empty?
    contents.nil?
  end

  def update(piece)
    @contents = piece
    self
  end

  def empty
    @contents = nil
    self
  end

  def generate_child(step)
    child = Square.new(x: x+step[0], y: y+step[1], parent: self) if (x+step[0]).between?(0,7) && (y+step[1]).between?(0,7)
  end
end
