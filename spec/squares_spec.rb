require './lib/squares'

describe Squares do

  let(:empty_square) { Square.new(x:1, y:2) }
  let(:full_square) { Square.new(x:3, y:4, contents: 'piece') }
  let(:squares) { Squares.new([empty_square, full_square]) }

  describe "#locate(piece)" do
    it "returns the coordinates of the given piece" do
      expect(squares.locate('piece')).to eql([3,4])
    end
  end

  describe "#empty?(location)" do
    context "when the square at the given location is empty" do
      it "returns true" do
        expect(squares.empty?([1,2])).to be true
      end
    end

    context "when the square at the given location is not empty" do
      it "returns false" do
        expect(squares.empty?([3,4])).to be false
      end
    end
  end

  describe "#get_piece(location)" do
    it "returns the piece at the given location" do
      expect(squares.get_piece([3,4])).to eql('piece')
    end
  end

  describe "#update(location, piece)" do
    it "adds the piece to the given location" do
      location = [1,2]
      piece = 'another_piece'
      squares.update(location, piece)
      expect(squares.get_piece(location)).to eql('another_piece')
    end

    it "updates the piece at the given location" do
      location = [3,4]
      piece = 'another_piece'
      squares.update(location, piece)
      expect(squares.get_piece(location)).to eql('another_piece')
    end
  end

  describe "#empty(location)" do
    it "removes the piece from the given location" do
      location = [3,4]
      squares.empty(location)
      expect(squares.empty?(location)).to be true
    end
  end
end