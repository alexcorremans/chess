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

  private

  def search_squares_by_contents(piece)
    find { |square| square.contents == piece }
  end

  def search_squares_by_coordinates(x,y)
    find { |square| square.x == x && square.y == y }
  end
end

module SquaresFactory
  def self.build(config:, square_class: Square, squares_class: Squares)
    squares_class.new(
      config.collect do |square_config|
        square_class.new(
          x: square_config[0],
          y: square_config[1],
          contents: square_config.fetch(2, nil)
        )
      end
    )
  end
end

white_rook = "white_rook"
white_knight = "white_knight"
white_bishop = "white_bishop"
white_queen = "white_queen"
white_king = "white_king"
white_pawn = "white_pawn"


board_config = 
  [[0, 0, white_rook],
   [1, 0, white_knight],
   [2, 0, white_bishop],
   [3, 0, white_queen],
   [4, 0, white_king],
   [5, 0, white_bishop],
   [6, 0, white_knight],
   [7, 0, white_rook],
   [0, 1, white_pawn],
   [1, 1, white_pawn],
   [2, 1, white_pawn],
   [3, 1, white_pawn],
   [4, 1, white_pawn],
   [5, 1, white_pawn],
   [6, 1, white_pawn],
   [7, 1, white_pawn],
   [0, 2],
   [1, 2],
   [2, 2],
   [3, 2],
   [4, 2],
   [5, 2],
   [6, 2],
   [7, 2]]

squares = SquaresFactory.build(config: board_config)
p squares.locate(white_bishop)
p squares.empty?([4,2])