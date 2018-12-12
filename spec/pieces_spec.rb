require './lib/pieces'

describe Pieces do
  describe "#get_pieces(type, colour)" do
    let(:white_queen) { Queen.new('white') }
    let(:black_knight) { Knight.new('black') }
    let(:white_knight) { Knight.new('white')}
    let(:pieces) { Pieces.new([white_queen, black_knight, white_knight]) }

    context "when asked for a specific type" do
      it "returns all pieces of the given type and colour" do
        expect(pieces.get_pieces('knight','white')).to eql([white_knight])
      end
    end

    context "when asked for all types" do
      it "returns all pieces of the given colour" do
        expect(pieces.get_pieces('all','white')).to match_array([white_queen, white_knight])
      end
    end

    context "when no pieces found" do
      it "returns an empty array" do
        expect(pieces.get_pieces('rook','white')).to eql([])
      end
    end
  end
end