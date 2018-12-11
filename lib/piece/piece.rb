require_relative '../square'
require_relative 'directions'

class Piece
  include Directions
  attr_reader :colour, :type

  def initialize(colour)
    @colour = colour
    @type = self.class.to_s.downcase
    post_initialize
  end

  def can_move?(board, endpoint)
    pos = board.get_position(self)
    path = get_path(pos, endpoint)
    if path.nil?
      return false
    else
      return board.can_move?(self, path)
    end
  end

  def move(board, endpoint)
    pos = board.get_position(self)
    path = get_path(pos, endpoint)
    new_board = board.move(self, path)
    return new_board
  end

  protected

  def get_path(a,b)
    directions.each do |direction|
      path = try_path(a,b,direction)
      return path if !path.nil?
    end
    nil
  end

  def square(x,y,parent=nil)
    Square.new(x: x, y: y, parent: parent)
  end

  def convert_path(path)
    path.map do |square|
      [square.x, square.y]
    end
  end

  # subclasses may override

  def post_initialize
  end

  # subclasses should override

  def try_path(a,b,direction)
    raise NotImplementedError, "#{self.class} should have implemented..."
  end

  def directions
    []
  end 
end