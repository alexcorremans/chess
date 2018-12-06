class Square
  attr_reader :x, :y, :contents

  def initialize(x:, y:, contents: nil)
    @x = x
    @y = y
    @contents = contents
  end

  def empty?
    contents.nil?
  end

  def add(piece)
    contents = piece
  end

  def empty
    contents = nil
  end
end
