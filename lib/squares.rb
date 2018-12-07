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

  def empty?(coordinates)
    x = coordinates[0]
    y = coordinates[1]
    search_squares_by_coordinates(x,y).empty?
  end

  def add(location, piece)
    x = coordinates[0]
    y = coordinates[1]
    search_squares_by_coordinates(x,y).add(piece)
  end

  private

  def search_squares_by_contents(piece)
    find { |square| square.contents == piece }
  end

  def search_squares_by_coordinates(x,y)
    find { |square| square.x == x && square.y == y }
  end
end