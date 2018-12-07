%w{config board squares pieces square piece whitepawn blackpawn bishop rook knight queen king}.each { |l| require_relative l }

module BoardFactory
  def self.build(config: STANDARD_CONFIG, board_class: Board)
    squares = []
    pieces = []
    config.each do |square_config|
      square = create_square(square_config)
      if !square_config[2].nil?
        piece = create_piece(square_config)
        pieces.push(piece)
        square.add(piece)
      end
      squares.push(square)
    end
    board_class.new(
      squares: Squares.new(squares), 
      pieces: Pieces.new(pieces)
    )
  end

  def self.create_square(square_config, square_class: Square)
    square_class.new(x: square_config[0], y: square_config[1])
  end

  def self.create_piece(square_config)
    const_get(square_config[2]).new(square_config.fetch(3, nil))
  end
end