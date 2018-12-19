require './lib/board'

describe Board do  
  describe "#display(team)" do
    let(:squares) { instance_double(Squares) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }
    let(:printer) { instance_double(Printer) }

    context "when it's White's turn" do
      it "sends a message to Printer to display the board from White's perspective" do
        allow(Printer).to receive(:new).with(squares).and_return(printer)
        allow(printer).to receive(:display).with('white')
        board.display('white')
        expect(printer).to have_received(:display).with('white')        
      end
    end

    context "when it's Black's turn" do
      it "sends a message to Printer to display the board from White's perspective" do
        allow(Printer).to receive(:new).with(squares).and_return(printer)
        allow(printer).to receive(:display).with('black')
        board.display('black')
        expect(printer).to have_received(:display).with('black') 
      end
    end
  end

  describe "#get_pieces(type, colour)" do
    let(:squares) { instance_double(Squares) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }

    context "when no specific type provided" do
      it "returns an array with all pieces of the given colour" do
        allow(pieces).to receive(:get_pieces).with('all','black').and_return('black pieces')
        expect(board.get_pieces('black')).to eql('black pieces')
      end
    end

    context "when asked for a specific type" do
      it "returns an array with all pieces of the given type and colour" do
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
    let(:squares) { instance_double(Squares) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }

    it "returns the coordinates of the given piece" do
      allow(squares).to receive(:locate).with('a piece').and_return([3,4])
      expect(board.get_position('a piece')).to eql([3,4])
    end
  end

  describe "#clear_messages" do
    let(:squares) { instance_double(Squares) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces, messages: ["test message"]) }

    it "empties the messages variable" do
      board.clear_messages
      expect(board.messages).to eql([])
    end

    it "returns the new board state" do
        new_board = board.clear_messages
        expect(new_board).to eql(board)
    end
  end

  describe "#move_ok?(move)" do
    let(:squares) { instance_double(Squares) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }

    context "when the path isn't empty where it should be" do
      let(:path) { path = [[0,0],[1,1],[2,2]] }
      let(:piece) { instance_double(Piece) }
      let(:move) { Move.new(path: path, piece: piece) }
      
      before do
        allow(piece).to receive(:colour).and_return('white')
      end

      it "returns false" do
        allow(squares).to receive(:empty?).with([1,1]).and_return(false)
        expect(board.move_ok?(move)).to be false
      end
    end     

    context "when the piece says it's a normal move" do
      let(:path) { path = [[0,0],[1,1],[2,2]] }
      let(:piece) { instance_double(Piece) }
      let(:move) { Move.new(path: path, piece: piece) }
      
      before do
        allow(piece).to receive(:colour).and_return('white')
      end

      context "when one of the same player's pieces is at the endpoint" do
        it "returns false" do
          allow(squares).to receive(:empty?).with([1,1]).and_return(true)
          allow(squares).to receive(:empty?).with([2,2]).and_return(false)
          allow(squares).to receive(:get_piece).with([2,2]).and_return(piece)
          expect(board.move_ok?(move)).to be false
        end
      end

      context "when the endpoint is empty" do
        it "returns true" do
          allow(squares).to receive(:empty?).with([1,1]).and_return(true)
          allow(squares).to receive(:empty?).with([2,2]).and_return(true)
          expect(board.move_ok?(move)).to be true
        end
      end

      context "when one of the other player's pieces is at the endpoint" do
        let(:black_piece) { instance_double(Piece) }

        before do
          allow(black_piece).to receive(:colour).and_return('black')
          allow(squares).to receive(:empty?).with([1,1]).and_return(true)
          allow(squares).to receive(:empty?).with([2,2]).and_return(false)
          allow(squares).to receive(:get_piece).with([2,2]).and_return(black_piece)
        end

        context "when the moving piece is a pawn" do
          it "returns false" do
            allow(piece).to receive(:type).and_return('pawn')
            expect(board.move_ok?(move)).to be false
          end
        end

        context "when the moving piece is not a pawn" do
          it "returns true" do
            allow(piece).to receive(:type).and_return('bishop')
            expect(board.move_ok?(move)).to be true
          end
        end          
      end
    end
    
    context "when the piece says it's a special move" do
      context "when pawn - two steps" do
        let(:path) { [[4,1],[4,2],[4,3]] }
        let(:piece) { instance_double(WhitePawn) }
        let(:move) { Move.new(path: path, piece: piece, name: 'two steps') }

        before do
          allow(piece).to receive(:colour).and_return('white')
          allow(squares).to receive(:empty?).with([4,2]).and_return(true)
        end

        context "when the special move is OK given the current board state" do
          it "returns true" do
            allow(squares).to receive(:empty?).with([4,3]).and_return(true)
            expect(board.move_ok?(move)).to be true  
          end
        end
        context "when the special move is not OK given the current board state" do
          it "returns false" do
            allow(squares).to receive(:empty?).with([4,3]).and_return(false)
            expect(board.move_ok?(move)).to be false
          end
        end
      end

      context "when pawn - en passant" do
        let(:path) { [[2,3],[3,2]] }
        let(:piece) { instance_double(BlackPawn) }
        let(:move) { Move.new(path: path, piece: piece, name: 'capture') }
        let(:white_piece) { instance_double(WhitePawn) }

        before do
          allow(piece).to receive(:colour).and_return('black')
          allow(squares).to receive(:empty?).with([3,2]).and_return(true)
        end

        context "when the special move is OK given the current board state" do
          it "returns true" do
            last_move = Move.new(path: [[3,1],[3,2],[3,3]], piece: white_piece, name: 'two steps')
            board.send(:update_last_move, last_move)
            expect(board.move_ok?(move)).to be true
          end
        end
        context "when the special move is not OK given the current board state" do
          it "returns false" do
            last_move = Move.new(path: [[2,1],[2,2],[2,3]], piece: white_piece, name: 'two steps')
            board.send(:update_last_move, last_move)
            expect(board.move_ok?(move)).to be false
          end
        end
      end

      context "when pawn - normal capture" do
        let(:path) { [[4,2],[5,3]] }
        let(:piece) { instance_double(WhitePawn) }
        let(:move) { Move.new(path: path, piece: piece, name: 'capture') }
        let(:black_piece) { instance_double(BlackPawn) }

        before do
          allow(piece).to receive(:colour).and_return('white')
          allow(black_piece).to receive(:colour).and_return('black')
          allow(squares).to receive(:empty?).with([5,3]).and_return(false)
        end

        context "when the special move is OK given the current board state" do
          it "returns true" do
            allow(squares).to receive(:get_piece).with([5,3]).and_return(black_piece)
            expect(board.move_ok?(move)).to be true
          end
        end
        context "when the special move is not OK given the current board state" do
          it "returns false" do
            allow(squares).to receive(:get_piece).with([5,3]).and_return(piece)
            expect(board.move_ok?(move)).to be false
          end
        end
      end


      context "when king - castling" do
        let(:short_path) { [[4,0],[5,0],[6,0]]}
        let(:long_path) { [[4,7],[3,7],[2,7]] }
        let(:test_king) { instance_double(King) }
        let(:short_move) { Move.new(path: short_path, piece: test_king, name: 'castling') }
        let(:long_move) { Move.new(path: long_path, piece: test_king, name: 'castling') }
        let(:rook) { instance_double(Rook) }
        
        before do
          allow(test_king).to receive(:colour)
        end

        context "when the king has moved before" do
          it "returns false" do
            allow(squares).to receive(:empty?).with([5,0]).and_return(true)
            allow(test_king).to receive(:moved?).and_return(true)
            expect(board.move_ok?(short_move)).to be false
          end
        end

        context "when the king is in check" do
          it "returns false" do
            allow(squares).to receive(:empty?).with([3,7]).and_return(true)
            allow(test_king).to receive(:moved?).and_return(false)
            allow(board).to receive(:check?).and_return(true)
            expect(board.move_ok?(long_move)).to be false
          end
        end

        context "when long castling" do            
          before do
            allow(squares).to receive(:empty?).with([3,7]).and_return(true)
          end

          context "when the square the rook has to jump over isn't empty" do
            it "returns false" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([1,7]).and_return(false)
              expect(board.move_ok?(long_move)).to be false
            end
          end

          context "when the corner that should hold the rook is empty" do
            it "returns false" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([1,7]).and_return(true)
              allow(squares).to receive(:empty?).with([0,7]).and_return(true)
              expect(board.move_ok?(long_move)).to be false
            end
          end

          context "when the piece in the corner has moved already" do
            it "returns false" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([1,7]).and_return(true)
              allow(squares).to receive(:empty?).with([0,7]).and_return(false)
              allow(squares).to receive(:get_piece).with([0,7]).and_return(rook)
              allow(rook).to receive(:moved?).and_return(true)
              expect(board.move_ok?(long_move)).to be false
            end
          end

          context "when the king would have to move through check to castle" do
            it "returns false" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([1,7]).and_return(true)
              allow(squares).to receive(:empty?).with([0,7]).and_return(false)
              allow(squares).to receive(:get_piece).with([0,7]).and_return(rook)
              allow(rook).to receive(:moved?).and_return(false)
              allow(test_king).to receive(:can_move?).with(board, [3,7]).and_return(false)
              expect(board.move_ok?(long_move)).to be false
            end
          end

          context "when all of the rules are fulfilled given the current board state" do
            it "returns true" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([1,7]).and_return(true)
              allow(squares).to receive(:empty?).with([0,7]).and_return(false)
              allow(squares).to receive(:get_piece).with([0,7]).and_return(rook)
              allow(rook).to receive(:moved?).and_return(false)
              allow(test_king).to receive(:can_move?).with(board, [3,7]).and_return(true)
              expect(board.move_ok?(long_move)).to be true
            end
          end
        end

        context "when short castling" do
          before do
            allow(squares).to receive(:empty?).with([5,0]).and_return(true)
          end

          context "when the corner that should hold the rook is empty" do
            it "returns false" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([7,0]).and_return(true)
              expect(board.move_ok?(short_move)).to be false
            end
          end

          context "when the piece in the corner has moved already" do
            it "returns false" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([7,0]).and_return(false)
              allow(squares).to receive(:get_piece).with([7,0]).and_return(rook)
              allow(rook).to receive(:moved?).and_return(true)
              expect(board.move_ok?(short_move)).to be false
            end
          end

          context "when the king would have to move through check to castle" do
            it "returns false" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([7,0]).and_return(false)
              allow(squares).to receive(:get_piece).with([7,0]).and_return(rook)
              allow(rook).to receive(:moved?).and_return(false)
              allow(test_king).to receive(:can_move?).with(board, [5,0]).and_return(false)
              expect(board.move_ok?(short_move)).to be false
            end
          end

          context "when all of the rules are fulfilled given the current board state" do
            it "returns true" do
              allow(test_king).to receive(:moved?).and_return(false)
              allow(board).to receive(:check?).and_return(false)
              allow(squares).to receive(:empty?).with([7,0]).and_return(false)
              allow(squares).to receive(:get_piece).with([7,0]).and_return(rook)
              allow(rook).to receive(:moved?).and_return(false)
              allow(test_king).to receive(:can_move?).with(board, [5,0]).and_return(true)
              expect(board.move_ok?(short_move)).to be true
            end
          end
        end
      end        
    end
  end

  describe "#update(move)" do
    let(:squares) { instance_double(Squares) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }
    
    context "when the piece says it's a normal move" do
      let(:path) { [[0,0],[1,1],[2,2]] }
      let(:piece) { instance_double(Piece) }
      let(:move) { Move.new(piece: piece, path: path) }
      
      before do
        allow(piece).to receive(:type).and_return('bishop')
        allow(squares).to receive(:empty).with([0,0])
        allow(pieces).to receive(:set_moved).with(piece).and_return(piece)
        allow(squares).to receive(:update)
      end
      
      context "in all cases" do
        before do
          allow(squares).to receive(:empty?).with([2,2]).and_return(true)
        end

        it "sends a message to squares to empty the starting point" do
          board.update(move)
          expect(squares).to have_received(:empty).with([0,0])
        end

        it "sends a message to pieces to tell the piece that it has moved" do
          board.update(move)
          expect(pieces).to have_received(:set_moved).with(piece)
        end

        it "sends a message to squares to add the moved piece to the endpoint" do
          board.update(move)
          expect(squares).to have_received(:update).with([2,2],piece)
        end

        it "stores text confirming the move so the Game can print it out later" do
          board.update(move)
          expect(board.messages[-1]).to eql("You move your bishop.")
        end

        it "updates the board's most recent move" do
          board.update(move)
          expect(board.last_move).to eql(move)
        end
    
        it "returns the new board state" do
          new_board = board.update(move)
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
          allow(squares).to receive(:empty).with([2,2])
          allow(pieces).to receive(:remove).with(captured_piece)
        end

        it "sends a message to squares to remove the captured piece" do
          board.update(move)
          expect(squares).to have_received(:empty).with([2,2])
        end

        it "sends a message to pieces to remove the captured piece" do
          board.update(move)
          expect(pieces).to have_received(:remove).with(captured_piece)
        end

        it "stores text confirming the capture so the Game can print it out later" do
          board.update(move)
          expect(board.messages[-1]).to eql("You captured a knight!")
        end
      end
    end

    context "when the piece says it's a special move" do
      context "when pawn - two steps" do
        let(:path) { [[4,1],[4,2],[4,3]] }
        let(:piece) { instance_double(WhitePawn) }
        let(:move) { Move.new(path: path, piece: piece, name: 'two steps') }

        it "initiates the normal move process" do
          allow(board).to receive(:normal_move)
          board.update(move)
          expect(board).to have_received(:normal_move).with(move)
        end
      end

      context "when pawn - en passant" do
        let(:path) { [[3,4],[4,5]] }
        let(:white_pawn) { instance_double(WhitePawn) }
        let(:move) { Move.new(path: path, piece: white_pawn, name: 'capture') }
        let(:black_pawn) { instance_double(BlackPawn) }

        before do
          allow(squares).to receive(:empty?).with([4,5]).and_return(true)
          allow(squares).to receive(:empty).with([3,4])
          allow(pieces).to receive(:set_moved).with(white_pawn).and_return(white_pawn)
          allow(squares).to receive(:update).with([4,5], white_pawn)
          allow(black_pawn).to receive(:type).and_return('pawn')
          allow(black_pawn).to receive(:colour).and_return('black')
          allow(squares).to receive(:get_piece).with([4,4]).and_return(black_pawn)
          allow(squares).to receive(:empty).with([4,4])
          allow(pieces).to receive(:remove).with(black_pawn)
        end

        it "sends a message to squares to empty the starting point" do
          board.update(move)
          expect(squares).to have_received(:empty).with([3,4])
        end

        it "sends a message to pieces to tell the piece that it has moved" do
          board.update(move)
          expect(pieces).to have_received(:set_moved).with(white_pawn)
        end

        it "sends a message to squares to add the moved piece to the endpoint" do
          board.update(move)
          expect(squares).to have_received(:update).with([4,5], white_pawn)
        end

        it "stores text confirming the move so the Game can print it out later" do
          board.update(move)
          expect(board.messages[-2]).to eql("Your pawn moves en-passant.")
        end

        it "sends a message to pieces to remove the captured pawn" do
          board.update(move)
          expect(pieces).to have_received(:remove).with(black_pawn)
        end

        it "stores text confirming the capture so the Game can print it out later" do
          board.update(move)
          expect(board.messages[-1]).to eql("You captured a pawn!")
        end

        it "updates the board's most recent move" do
          board.update(move)
          expect(board.last_move).to eql(move)
        end
    
        it "returns the new board state" do
          new_board = board.update(move)
          expect(new_board).to eql(board)
        end
      end

      context "when pawn - normal capture" do
        let(:path) { [[4,2],[5,3]] }
        let(:pawn) { instance_double(WhitePawn) }
        let(:move) { Move.new(path: path, piece: pawn, name: 'capture') }

        it "initiates the normal move process" do
          allow(squares).to receive(:empty?).with([5,3]).and_return(false)
          allow(board).to receive(:normal_move)
          board.update(move)
          expect(board).to have_received(:normal_move).with(move)
        end
      end

      context "when king - castling" do        
        context "when long castling" do
          let(:path) { [[4,7],[3,7],[2,7]] }
          let(:king) { instance_double(King) }
          let(:move) { Move.new(path: path, piece: king, name: 'castling') }
          let(:rook) { instance_double(Rook) }

          before do
            allow(squares).to receive(:empty).with([4,7])
            allow(pieces).to receive(:set_moved).with(king).and_return(king)
            allow(squares).to receive(:update).with([2,7], king)
            allow(squares).to receive(:get_piece).with([0,7]).and_return(rook)
            allow(squares).to receive(:empty).with([0,7])
            allow(pieces).to receive(:set_moved).with(rook).and_return(rook)
            allow(squares).to receive(:update).with([3,7], rook)            
          end
  
          it "sends a message to squares to empty the starting point" do
            board.update(move)
            expect(squares).to have_received(:empty).with([4,7])
          end
  
          it "sends a message to pieces to tell the king that it has moved" do
            board.update(move)
            expect(pieces).to have_received(:set_moved).with(king)
          end
  
          it "sends a message to squares to add the moved king to the endpoint" do
            board.update(move)
            expect(squares).to have_received(:update).with([2,7], king)
          end

          it "sends a message to squares to find the rook" do
            board.update(move)
            expect(squares).to have_received(:get_piece).with([0,7])
          end

          it "sends a message to squares to empty the corner rook position" do
            board.update(move)
            expect(squares).to have_received(:empty).with([0,7])
          end

          it "sends a message to pieces to tell the rook that it has moved" do
            board.update(move)
            expect(pieces).to have_received(:set_moved).with(rook)
          end

          it "sends a message to squares to add the moved rook to its new position" do
            board.update(move)
            expect(squares).to have_received(:update).with([3,7], rook)
          end          

          it "stores text confirming the move so the Game can print it out later" do
            board.update(move)
            expect(board.messages[-1]).to eql("You move both your king and your rook in a castling move.")
          end
  
          it "updates the board's most recent move" do
            board.update(move)
            expect(board.last_move).to eql(move)
          end
      
          it "returns the new board state" do
            new_board = board.update(move)
            expect(new_board).to eql(board)
          end
        end

        context "when short castling" do
          let(:path) { [[4,0],[5,0],[6,0]] }
          let(:king) { instance_double(King) }
          let(:move) { Move.new(path: path, piece: king, name: 'castling') }
          let(:rook) { instance_double(Rook) }

          before do
            allow(squares).to receive(:empty).with([4,0])
            allow(pieces).to receive(:set_moved).with(king).and_return(king)
            allow(squares).to receive(:update).with([6,0], king)
            allow(squares).to receive(:get_piece).with([7,0]).and_return(rook)
            allow(squares).to receive(:empty).with([7,0])
            allow(pieces).to receive(:set_moved).with(rook).and_return(rook)
            allow(squares).to receive(:update).with([5,0], rook)            
          end
  
          it "sends a message to squares to empty the starting point" do
            board.update(move)
            expect(squares).to have_received(:empty).with([4,0])
          end
  
          it "sends a message to pieces to tell the king that it has moved" do
            board.update(move)
            expect(pieces).to have_received(:set_moved).with(king)
          end
  
          it "sends a message to squares to add the moved king to the endpoint" do
            board.update(move)
            expect(squares).to have_received(:update).with([6,0], king)
          end

          it "sends a message to squares to find the rook" do
            board.update(move)
            expect(squares).to have_received(:get_piece).with([7,0])
          end

          it "sends a message to squares to empty the corner rook position" do
            board.update(move)
            expect(squares).to have_received(:empty).with([7,0])
          end

          it "sends a message to pieces to tell the rook that it has moved" do
            board.update(move)
            expect(pieces).to have_received(:set_moved).with(rook)
          end

          it "sends a message to squares to add the moved rook to its new position" do
            board.update(move)
            expect(squares).to have_received(:update).with([5,0], rook)
          end          

          it "stores text confirming the move so the Game can print it out later" do
            board.update(move)
            expect(board.messages[-1]).to eql("You move both your king and your rook in a castling move.")
          end
  
          it "updates the board's most recent move" do
            board.update(move)
            expect(board.last_move).to eql(move)
          end
      
          it "returns the new board state" do
            new_board = board.update(move)
            expect(new_board).to eql(board)
          end
        end
      end
    end
  end

  describe "#move_causes_check?(move)" do
    let(:squares) { instance_double(Squares) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }

    let(:path) { [[0,0],[1,1],[2,2]] }
    let(:bishop) { instance_double(Piece) }
    let(:move) { Move.new(piece: bishop, path: path) }

    let(:new_squares) { instance_double(Squares) }
    let(:new_pieces) { instance_double(Pieces) }
    let(:new_board) { Board.new(squares: new_squares, pieces: new_pieces) } 
    let(:new_bishop) { instance_double(Bishop) }
    
    before do
      allow(board).to receive(:duplicate).and_return(new_board)
      allow(squares).to receive(:locate).with(bishop).and_return([0,0])
      allow(new_squares).to receive(:get_piece).with([0,0]).and_return(new_bishop)
      allow(bishop).to receive(:colour).and_return('white')
      allow(new_bishop).to receive(:move).with(new_board, [2,2]).and_return(new_board)
    end

    context "when the given move causes the team's king to be in check" do
      it "returns true" do
        allow(new_board).to receive(:check?).with('white').and_return(true)
        expect(board.move_causes_check?(move)).to be true
      end
    end

    context "when the given move doesn't cause the team king to be in check" do
      it "returns false" do
        allow(new_board).to receive(:check?).with('white').and_return(false)
        expect(board.move_causes_check?(move)).to be false
      end
    end
  end

  describe "#check?(team)" do
    let(:squares) { instance_double(Squares) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }
    
    let(:white_king) { instance_double(King) }
    let(:white_queen) { instance_double(Queen) }
    let(:black_rook) { instance_double(Rook) }
    let(:black_bishop) { instance_double(Bishop) }
    let(:white_pieces) { [white_king, white_queen] }
    let(:black_pieces) { [black_rook, black_bishop] }

    before do
      allow(pieces).to receive(:get_king).with('white').and_return(white_king)
      allow(squares).to receive(:locate).with(white_king).and_return([0,0])
      allow(pieces).to receive(:get_pieces).with('all', 'black').and_return(black_pieces)
    end

    context "when the team's king is in check" do
      it "returns true" do
        allow(black_rook).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
        allow(black_bishop).to receive(:move_allowed?).with(board, [0,0]).and_return(true)
        expect(board.check?('white')).to be true
      end
    end

    context "when the team's king is not in check" do
      it "returns false" do
        allow(black_rook).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
        allow(black_bishop).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
        expect(board.check?('white')).to be false
      end
    end
  end

 describe "#check_mate?(team)" do
    let(:white_king) { instance_double(King) }
    let(:white_queen) { instance_double(Queen) }
    let(:white_pieces) { [white_king, white_queen] }
    let(:black_rook) { instance_double(Rook) }
    let(:black_bishop) { instance_double(Bishop) }
    let(:black_pieces) { [black_rook, black_bishop] }
    let(:square1) { instance_double(Square) }
    let(:square2) { instance_double(Square) }
    let(:squares) { Squares.new([square1, square2]) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }

    before do
      allow(square1).to receive(:coordinates).and_return([0,0])
      allow(square2).to receive(:coordinates).and_return([1,1])
    end

    context "when the player's king is not in check" do
      before do
        allow(pieces).to receive(:get_king).with('white').and_return(white_king)
        allow(squares).to receive(:locate).with(white_king).and_return([0,0])
        allow(pieces).to receive(:get_pieces).with('all', 'black').and_return(black_pieces)
        allow(black_rook).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
        allow(black_bishop).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
      end
      
      it "returns false" do
        expect(board.checkmate?('white')).to be false
      end
    end
    
    context "when the player's king is in check" do
      before do
        allow(pieces).to receive(:get_king).with('white').and_return(white_king)
        allow(squares).to receive(:locate).with(white_king).and_return([0,0])
        allow(pieces).to receive(:get_pieces).with('all', 'black').and_return(black_pieces)
        allow(black_rook).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
        allow(black_bishop).to receive(:move_allowed?).with(board, [0,0]).and_return(true)
      end

      context "when the player has no possible moves" do
        it "returns true" do
          allow(pieces).to receive(:get_pieces).with('all', 'white').and_return(white_pieces)
          allow(white_king).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
          allow(white_king).to receive(:move_allowed?).with(board, [1,1]).and_return(false)
          allow(white_queen).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
          allow(white_queen).to receive(:move_allowed?).with(board, [1,1]).and_return(false)
          expect(board.checkmate?('white')).to be true
        end
      end

      context "when the player still has possible moves" do
        context "when all the possible moves still leave the king in check" do
          it "returns true" do
            allow(pieces).to receive(:get_pieces).with('all', 'white').and_return(white_pieces)
            allow(white_king).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
            allow(white_king).to receive(:move_allowed?).with(board, [1,1]).and_return(true)
            allow(white_queen).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
            allow(white_queen).to receive(:move_allowed?).with(board, [1,1]).and_return(false)
            allow(white_king).to receive(:no_check?).with(board, [1,1]).and_return(false)
            expect(board.checkmate?('white')).to be true
          end
        end
        context "when one of the possible moves removes the check" do
          it "returns false" do
            allow(pieces).to receive(:get_pieces).with('all', 'white').and_return(white_pieces)
            allow(white_king).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
            allow(white_king).to receive(:move_allowed?).with(board, [1,1]).and_return(true)
            allow(white_queen).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
            allow(white_queen).to receive(:move_allowed?).with(board, [1,1]).and_return(false)
            allow(white_king).to receive(:no_check?).with(board, [1,1]).and_return(true)
            expect(board.checkmate?('white')).to be false
          end
        end
      end
    end
  end

  describe "#stalemate?(team)" do
    let(:white_king) { instance_double(King) }
    let(:white_queen) { instance_double(Queen) }
    let(:white_pieces) { [white_king, white_queen] }
    let(:black_rook) { instance_double(Rook) }
    let(:black_bishop) { instance_double(Bishop) }
    let(:black_pieces) { [black_rook, black_bishop] }
    let(:square1) { instance_double(Square) }
    let(:square2) { instance_double(Square) }
    let(:squares) { Squares.new([square1, square2]) }
    let(:pieces) { instance_double(Pieces) }
    let(:board) { Board.new(squares: squares, pieces: pieces) }

    before do
      allow(square1).to receive(:coordinates).and_return([0,0])
      allow(square2).to receive(:coordinates).and_return([1,1])
    end

    context "when the player's king is in check" do
      before do
        allow(pieces).to receive(:get_king).with('white').and_return(white_king)
        allow(squares).to receive(:locate).with(white_king).and_return([0,0])
        allow(pieces).to receive(:get_pieces).with('all', 'black').and_return(black_pieces)
        allow(black_rook).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
        allow(black_bishop).to receive(:move_allowed?).with(board, [0,0]).and_return(true)
      end

      it "returns false" do
        expect(board.stalemate?('white')).to be false
      end
    end

    context "when the player's king is not in check" do
      before do
        allow(pieces).to receive(:get_king).with('white').and_return(white_king)
        allow(squares).to receive(:locate).with(white_king).and_return([0,0])
        allow(pieces).to receive(:get_pieces).with('all', 'black').and_return(black_pieces)
        allow(black_rook).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
        allow(black_bishop).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
      end

      context "when the player has no possible moves" do
        it "returns true" do
          allow(pieces).to receive(:get_pieces).with('all', 'white').and_return(white_pieces)
          allow(white_king).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
          allow(white_king).to receive(:move_allowed?).with(board, [1,1]).and_return(false)
          allow(white_queen).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
          allow(white_queen).to receive(:move_allowed?).with(board, [1,1]).and_return(false)
          expect(board.stalemate?('white')).to be true
        end
      end

      context "when the player still has possible moves" do
        context "when all the possible moves still leave the king in check" do
          it "returns true" do
            allow(pieces).to receive(:get_pieces).with('all', 'white').and_return(white_pieces)
            allow(white_king).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
            allow(white_king).to receive(:move_allowed?).with(board, [1,1]).and_return(true)
            allow(white_queen).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
            allow(white_queen).to receive(:move_allowed?).with(board, [1,1]).and_return(false)
            allow(white_king).to receive(:no_check?).with(board, [1,1]).and_return(false)
            expect(board.stalemate?('white')).to be true
          end
        end
        context "when one of the possible moves removes the check" do
          it "returns false" do
            allow(pieces).to receive(:get_pieces).with('all', 'white').and_return(white_pieces)
            allow(white_king).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
            allow(white_king).to receive(:move_allowed?).with(board, [1,1]).and_return(true)
            allow(white_queen).to receive(:move_allowed?).with(board, [0,0]).and_return(false)
            allow(white_queen).to receive(:move_allowed?).with(board, [1,1]).and_return(false)
            allow(white_king).to receive(:no_check?).with(board, [1,1]).and_return(true)
            expect(board.stalemate?('white')).to be false
          end
        end
      end
    end
  end
end