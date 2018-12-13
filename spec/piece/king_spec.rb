require_relative 'shared_examples_for_pieces'
require './lib/piece/king'

describe King do
  let(:subject) { King.new('white') }

  it_behaves_like 'a Piece'
  it_behaves_like 'a PieceSubclass'

  describe "#try_path(a,b,direction)" do
    context "when a path exists going from a to b in a given direction in one step" do
      it "returns the path as an array of coordinates" do
        a = [3,3]
        b = [3,2]
        direction = subject.down      
        result = [[3,3],[3,2]]
        expect(subject.try_path(a,b,direction)).to eql(result)
      end
    end

    context "when no path can be found in the given direction" do
      it "returns nil" do
        a = [3,3]
        b = [3,4]
        direction = subject.down
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end

    context "when b can't be reached in one step" do
      it "returns nil" do
        a = [3,3]
        b = [3,5]
        direction = subject.up
        expect(subject.try_path(a,b,direction)).to be nil
      end
    end

    context "when b is outside of the board" do
      it "returns nil" do
        a = [0,0]
        b = [-1,0]
        direction = subject.left
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
        subject.left,
        subject.diagonal_right_up,
        subject.diagonal_right_down,
        subject.diagonal_left_up,
        subject.diagonal_left_down
      ]
      expect(subject.directions).to match_array(directions)
    end
  end

  describe "#special_moves" do
    it "supplies the allowed special moves" do
      result = [
        'castling'
      ]
      expect(subject.special_moves).to match_array(result)
    end
  end

  describe "#get_special_move(a,b)" do
    let(:white_king) { King.new('white') }
    let(:black_king) { King.new('black') }

    context "when b is outside of the board" do
      it "returns nil" do
        a = [6,0]
        b = [8,0]
        expect(white_king.get_special_move(a,b)).to be nil
      end
    end

    context "when the requested move is one of the piece's special moves" do
      context "when the king can do a long castling move" do
        it "returns a move-like object that can be queried for the piece, the path from a to b and the name of the special move" do
          a = [4,0]
          b = [6,0]
          expect(white_king.get_special_move(a,b).piece).to eql(white_king)
          expect(white_king.get_special_move(a,b).path).to eql([[4,0],[5,0],[6,0]])
          expect(white_king.get_special_move(a,b).name).to eql('castling')
        end
      end

      context "when the king can do a short castling move" do
        it "returns a move-like object that can be queried for the piece, the path from a to b and the name of the special move" do
          a = [4,7]
          b = [2,7]
          expect(black_king.get_special_move(a,b).piece).to eql(black_king)
          expect(black_king.get_special_move(a,b).path).to eql([[4,7],[3,7],[2,7]])
          expect(black_king.get_special_move(a,b).name).to eql('castling')
        end
      end
    end

    context "when the requested move is not one of the piece's special moves" do
      it "returns nil" do
        a = [4,0]
        b = [2,0]
        expect(black_king.get_special_move(a,b)).to be nil
      end
    end
  end
end