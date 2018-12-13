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
    return false if pos == endpoint
    path = get_path(pos, endpoint)
    if !path.nil?
      return board.can_move?(self, path)
    elsif path.nil? && special_moves?
      special_move = get_special_move(pos, endpoint)
      if !special_move.nil?
        path = special_move[:path]
        move_name = special_move[:name]
        return board.can_move?(self, path, move_name)
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
      path = special_move[:path]
      move_name = special_move[:name]
      new_board = board.move(self, path, move_name)
      return new_board
    else
      new_board = board.move(self, path)
      return new_board
    end
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