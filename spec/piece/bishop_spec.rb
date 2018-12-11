require_relative 'shared_examples_for_pieces'
require './lib/piece/bishop'

describe Bishop do
  let(:subject) { Bishop.new('white') }

  it_behaves_like 'a Piece'
  it_behaves_like 'a PieceSubclass'

  describe "#try_path(a,b,direction)" do
    context "when a path exists going from a to b in a given direction" do
      it "returns the path as an array of coordinates" do
        a = [0,0]
        b = [3,3]
        direction = subject.diagonal_right_up      
        result = [[0,0],[1,1],[2,2],[3,3]]
        expect(subject.try_path(a,b,direction)).to eql(result)
      end
    end

    context "when no path can be found in the given direction" do
      it "returns nil" do
        a = [0,0]
        b = [3,3]
        direction = subject.diagonal_right_down
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end

    context "when b is outside of the board" do
      it "returns nil" do
        a = [0,0]
        b = [8,8]
        direction = subject.diagonal_right_up
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end   
  end

  describe "#directions" do
    it "supplies the allowed directions" do
      directions = [
        subject.diagonal_right_up,
        subject.diagonal_right_down,
        subject.diagonal_left_up,
        subject.diagonal_left_down
      ]
      expect(subject.directions).to match_array(directions)
    end
  end
end