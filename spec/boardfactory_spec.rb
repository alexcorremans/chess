require './lib/boardfactory'
require 'yaml'

describe BoardFactory do
  describe "#build" do
    context "when not provided with any specific configuration" do
      it "creates a chess board with the standard configuration" do
        classic_board = File.read('spec/boards/classic_board.yml')
        board = BoardFactory.build
        expect(board.to_yaml).to eql(classic_board)
      end
    end

    context "when provided with a different configuration" do
      it "creates a chess board with the correct configuration" do
        SPECIAL_CONFIG = 
        [ [0, 0, 'Queen',     'white'],
          [1, 0, 'King',   'black'],
          [2, 0, 'WhitePawn'],
          [3, 0, 'BlackPawn']]
        special_board = File.read('spec/boards/special_board.yml')
        board = BoardFactory.build(config: SPECIAL_CONFIG)
        expect(board.to_yaml).to eql(special_board)
      end
    end
  end
end

