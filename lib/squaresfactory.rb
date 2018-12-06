require_relative 'square'
require_relative 'squares'

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