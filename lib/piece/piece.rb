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

  def can_move?(board, end_pos)
    move_allowed?(board, end_pos) && no_check?(board, end_pos)
  end

  def move_allowed?(board, end_pos)
    pos = board.get_position(self)
    return false if pos == end_pos
    path = get_path(pos, end_pos)
    if !path.nil?
      move = create_move(self, path)
      return board.move_ok?(move)
    elsif path.nil? && special_moves?
      special_move = get_special_move(pos, end_pos)
      if !special_move.nil?
        return board.move_ok?(special_move)
      else
        return false
      end
    else
      return false
    end
  end

  def no_check?(board, end_pos)
    pos = board.get_position(self)
    return false if pos == end_pos
    path = get_path(pos, end_pos)
    if !path.nil?
      move = create_move(self, path)
      return !board.move_causes_check?(move)
    elsif path.nil? && special_moves?
      special_move = get_special_move(pos, end_pos)
      if !special_move.nil?
        return !board.move_causes_check?(special_move)
      else
        return false
      end
    else
      return false      
    end
  end

  def move(board, end_pos)
    pos = board.get_position(self)
    path = get_path(pos, end_pos)
    if path.nil? 
      special_move = get_special_move(pos, end_pos)
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