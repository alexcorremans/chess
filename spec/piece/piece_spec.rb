require_relative 'shared_examples_for_pieces'
require './lib/piece/piece'

class PieceDouble < Piece
  def try_path(a,b,direction)
    case direction
    when 'up'
      if a == 0 && b == 1
        return 'moved up'
      else
        return nil
      end
    when 'down'
      if a == 0 && b == -1
        return 'moved down' 
      else
        return nil
      end
    end
  end

  def directions
    ['up','down']
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

  describe "#get_path(a,b)" do
    let(:double) { PieceDouble.new('black') }
    it "iterates over subclass's try_path results for each direction supplied by the subclass" do
      expect(double.get_path(0,1)).to eql('moved up')
      expect(double.get_path(0,-1)).to eql('moved down')
    end

    it "returns nil if after iteration no path was found" do
      expect(double.get_path(0,0)).to be nil
    end
  end
end