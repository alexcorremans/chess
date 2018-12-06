class Board
  attr_reader :squares

  def initialize(squares)
    @squares = squares
  end

  def display(colour)
  end

  def move(piece, dest)
  end

  private

  def locate(piece)
    squares.locate(piece)
  end

  def empty?(coordinates)
    squares.empty?(coordinates)
  end
end