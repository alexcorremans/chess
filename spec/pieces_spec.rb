require './lib/pieces'

describe Pieces do
  let(:white_queen) { Queen.new('white') }
  let(:black_knight) { Knight.new('black') }
  let(:white_knight) { Knight.new('white')}
  let(:black_king) { King.new('black') }
  let(:pieces) { Pieces.new([white_queen, black_knight, white_knight, black_king]) }
    
  describe "#get_pieces(type, colour)" do
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

  describe "#get_king(team)" do
    it "returns the king of the given colour" do
      expect(pieces.get_king('black')).to eql(black_king)
    end
  end

  describe "#remove(piece)" do
    it "removes the given piece from the array" do
      pieces.remove(black_knight)
      expect(pieces).to match_array([white_queen, white_knight, black_king])
    end
  end

  describe "#set_moved(piece)" do
    it "updates the pieces array with the moved piece" do
      pieces.set_moved(black_knight)
      expect(pieces.get_pieces('knight', 'black')[0].moved?).to be true
    end

    it "returns the moved piece" do
      expect(pieces.set_moved(black_knight)).to eql(black_knight.set_moved)
    end
  end
end