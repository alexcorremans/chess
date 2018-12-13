require './lib/board'

describe Board do
  before do
    allow($stdout).to receive(:write)
  end
  
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
    context "when the piece says it's a normal move" do
      context "when the path isn't empty where it should be" do
        it "returns false"
      end

      context "when the move is OK given the current board state" do
        it "returns true"
      end
    end
    
    context "when the piece says it's a special move" do
      context "when the special move is OK" do
        it "returns true"
      end
      context "when the special move is not OK" do
        it "returns false"
      end
    end
  end

  describe "#move(piece, path)" do
    let(:path) { [[0,0],[1,1],[2,2]] }
    
    before do
      allow(squares).to receive(:empty).with([0,0])
      allow(squares).to receive(:add)
    end
    
    context "in all cases" do
      before do
        allow(squares).to receive(:empty?).with([2,2]).and_return(true)
      end

      it "sends a message to squares to empty the starting point" do
        board.move('a piece', path)
        expect(squares).to have_received(:empty).with([0,0])
      end

      it "sends a message to squares to add the piece to the endpoint" do
        board.move('a piece', path)
        expect(squares).to have_received(:add).with([2,2],'a piece')
      end
  
      it "returns the new board state" do
        new_board = board.move('a piece', path)
        expect(new_board).to eql(board)
      end
    end

    context "when the move is a capture" do
      let(:captured_piece) { instance_double(Piece) }
      before do
        allow(captured_piece).to receive(:type).and_return('knight')
        allow(captured_piece).to receive(:colour).and_return('white')
        allow(squares).to receive(:empty?).with([2,2]).and_return(false)
        allow(squares).to receive(:get_piece).with([2,2]).and_return(captured_piece)
        allow(pieces).to receive(:remove).with(captured_piece)
        allow(squares).to receive(:empty).with([2,2])

      end

      it "prints a message confirming the capture" do
        expect{ board.move('a piece', path) }.to output(
          "You captured a white knight!\n"
        ).to_stdout
      end

      it "sends a message to pieces to remove the captured piece" do
        board.move('a piece', path)
        expect(pieces).to have_received(:remove).with(captured_piece)
      end

      it "sends a message to squares to empty the endpoint" do
        board.move('a piece', path)
        expect(squares).to have_received(:empty).with([2,2])
      end
    end
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