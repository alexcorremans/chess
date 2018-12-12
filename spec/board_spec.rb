require './lib/board'

describe Board do
  describe "#display(team)" do
    context "when it's White's turn" do
      it "displays the board from White's perspective"
    end

    context "when it's Black's turn" do
      it "displays the board from Black's perspective"
    end
  end

  let(:squares) { instance_double(Squares) }
  let(:pieces) { instance_double(Pieces) }
  let(:board) { Board.new(squares: squares, pieces: pieces) }

  describe "#get_pieces(type, colour)" do
    context "when no specific type provided" do
      it "returns all pieces of the given colour" do
        allow(pieces).to receive(:get_pieces).with('all','black').and_return('black pieces')
        expect(board.get_pieces('black')).to eql('black pieces')
      end
    end

    context "when asked for a specific type" do
      it "returns all pieces of the given type and colour" do
        allow(pieces).to receive(:get_pieces).with('knight', 'white').and_return('white knights')
        expect(board.get_pieces('knight','white')).to eql('white knights')
      end
    end

    context "when no pieces found" do
      it "returns an empty array" do
        allow(pieces).to receive(:get_pieces).with('knight', 'white').and_return([])
        expect(board.get_pieces('knight','white')).to eql([])
      end
    end
  end

  describe "#get_position(piece)" do
    it "returns the coordinates of the given piece" do
      allow(squares).to receive(:locate).with('a piece').and_return([3,4])
      expect(board.get_position('a piece')).to eql([3,4])
    end
  end

  describe "#can_move?(piece, path)" do
    context "when the path isn't empty where it should be" do
      it "returns false"
    end

    context "when the move is OK given the current board state" do
      it "returns true"
    end
  end

  describe "#move(piece, path)" do
    it "sends a message to squares to empty the starting point"

    context "when the move is a capture" do
      it "sends a message to pieces to remove the captured piece"

      it "sends a message to squares to empty the endpoint"
    end

    it "sends a message to squares to add the piece to the endpoint"

    it "returns the new board state"
  end

  describe "#check?(team)" do
    context "when the team's king is in check" do
      it "returns true"
    end

    context "when the team's king is not in check" do
      it "returns false"
    end
  end

  describe "#check_mate?(team)" do
    context "when the team's king is mated" do
      it "returns true"
    end

    context "when the team's king is not mated" do
      it "returns false"
    end
  end
end