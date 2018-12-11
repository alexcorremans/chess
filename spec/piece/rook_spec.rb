require_relative 'shared_examples_for_pieces'
require './lib/piece/rook'

describe Rook do
  let(:subject) { Rook.new('white') }

  it_behaves_like 'a Piece'
  it_behaves_like 'a PieceSubclass'

  describe "#try_path(a,b,direction)" do
    context "when a path exists going from a to b in a given direction" do
      it "returns the path as an array of coordinates" do
        a = [0,0]
        b = [3,0]
        direction = subject.right      
        result = [[0,0],[1,0],[2,0],[3,0]]
        expect(subject.try_path(a,b,direction)).to eql(result)
      end
    end

    context "when no path can be found in the given direction" do
      it "returns nil" do
        a = [0,0]
        b = [3,0]
        direction = subject.up
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end

    context "when b is outside of the board" do
      it "returns nil" do
        a = [0,0]
        b = [0,8]
        direction = subject.right
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end   
  end

  describe "#directions" do
    it "supplies the allowed directions" do
      directions = [
        subject.up,
        subject.down,
        subject.right,
        subject.left
      ]
      expect(subject.directions).to match_array(directions)
    end
  end
end