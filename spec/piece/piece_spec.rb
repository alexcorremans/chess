require_relative 'shared_examples_for_pieces'
require './lib/piece/piece'
require './lib/board'

class PieceDouble < Piece
  def try_path(a,b,direction)
    case direction
    when 'up'
      if a == [0,0] && b == [0,1]
        return 'moved up'
      else
        return nil
      end
    when 'down'
      if a == [0,3] && b == [0,2]
        return 'moved down'
      else
        return nil
      end
    end
  end

  def directions
    ['up', 'down']
  end
end

describe PieceDouble do
  let(:subject) { PieceDouble.new('black') }

  it_behaves_like 'a PieceSubclass'
end

describe Piece do
  let(:subject) { Piece.new('white') }

  it_behaves_like 'a Piece'

  describe "#try_path" do
    it "forces subclasses to implement #try_path" do
      expect{ subject.try_path('a','b','direction') }.to raise_error(NotImplementedError)
    end
  end

  let(:double) { PieceDouble.new('black') }
  let(:board) { instance_double(Board) }
  
  before { allow(board).to receive(:get_position).and_return([0,0]) }

  describe "#can_move?(board, endpoint)" do
    context "when the endpoint is somewhere the piece can't go" do
      it "returns false" do
        expect(double.can_move?(board, [2,0])).to be false
      end
    end

    context "when the current board state doesn't allow the piece to go there" do
      it "returns false" do
        allow(board).to receive(:can_move?).and_return(false)
        expect(double.can_move?(board, [0,1])).to be false
      end
    end

    context "when the piece can go there and the board allows it" do
      it "returns true" do
        allow(board).to receive(:can_move?).and_return(true)
        expect(double.can_move?(board, [0,1])).to be true
      end
    end

  end

  describe "#move(board, endpoint)" do
    it "sends #move(self,path) to the board" do
      allow(board).to receive(:move)
      double.move(board, [0,1])
      expect(board).to have_received(:move)
    end
    
    it "returns the new board state" do
      allow(board).to receive(:move).and_return('new board')
      expect(double.move(board, [0,1])).to eql('new board')
    end
  end

# private method test

  describe "#get_path(a,b) (private method)" do
    it "iterates over subclass's try_path results for each direction supplied by the subclass" do
      expect(double.get_path([0,0],[0,1])).to eql('moved up')
      expect(double.get_path([0,3],[0,2])).to eql('moved down')
    end

    it "returns nil if after iteration no path was found" do
      expect(double.get_path([0,0],[2,0])).to be nil
    end
  end
end