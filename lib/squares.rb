require_relative 'square'
require 'forwardable'
class Squares
  extend Forwardable
  def_delegator :@squares, :each
  include Enumerable

  def initialize(squares)
    @squares = squares
  end

  def locate(piece)
    search_squares_by_contents(piece).coordinates
  end

  def empty?(location)
    x = location[0]
    y = location[1]
    search_squares_by_location(x,y).empty?
  end

  def get_piece(location)
    x = location[0]
    y = location[1]
    search_squares_by_location(x,y).contents
  end

  def update(location, piece)
    x = location[0]
    y = location[1]
    new_square = search_squares_by_location(x,y).update(piece)
    update_self(new_square)
  end

  def empty(location)
    x = location[0]
    y = location[1]
    new_square = search_squares_by_location(x,y).empty
    update_self(new_square)
  end

  private

  def update_self(new_square)
    @squares = self.map do |square|
      same_location?(square, new_square) ? new_square : square
    end
  end

  def same_location?(square, other_square)
    square.x == other_square.x && square.y == other_square.y
  end

  def search_squares_by_contents(piece)
    find { |square| square.contents == piece }
  end

  def search_squares_by_location(x,y)
    find { |square| square.x == x && square.y == y }
  end
end