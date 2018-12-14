require_relative '../square'
require_relative '../move'
require_relative 'directions'

class Piece
  include Directions
  attr_reader :colour, :type, :moved

  def initialize(colour)
    @colour = colour
    @type = self.class.to_s.downcase
    @moved = false
    post_initialize
  end

  def can_move?(board, endpoint)
    pos = board.get_position(self)
    return false if pos == endpoint
    path = get_path(pos, endpoint)
    if !path.nil?
      move = create_move(self, path)
      return board.move_allowed?(move)
    elsif path.nil? && special_moves?
      special_move = get_special_move(pos, endpoint)
      if !special_move.nil?
        return board.move_allowed?(special_move)
      else
        return false
      end
    else
      return false      
    end
  end

  def move(board, endpoint)
    pos = board.get_position(self)
    path = get_path(pos, endpoint)
    if path.nil? 
      special_move = get_special_move(pos, endpoint)
      new_board = board.update(special_move)
      return new_board
    else
      move = create_move(self, path)
      new_board = board.update(move)
      return new_board
    end
  end

  def set_moved
    @moved = true
    self
  end

  def moved?
    moved == true
  end

  # end of public interface

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

  def create_move(piece, path, move_name=nil)
    Move.new(piece: piece, path: path, name: move_name)
  end

  def convert_path(path)
    path.map do |square|
      [square.x, square.y]
    end
  end

  def special_moves?
    !special_moves.empty?
  end

  # subclasses may override

  def post_initialize
  end

  def special_moves
    []
  end

  def get_special_move(a,b)
  end

  # subclasses should override

  def try_path(a,b,direction)
    raise NotImplementedError, "#{self.class} should have implemented..."
  end

  def directions
    raise NotImplementedError, "#{self.class} should have implemented..."
  end
end