require './lib/player'

describe Player do
  before do
    allow($stdout).to receive(:write)
  end

  describe "#play" do
    let(:player) { Player.new(team: 'white', name: 'tester') }
    let(:board) { instance_double(Board) }

    it "asks the player for input" do
      choice = {type: 'other', contents: 'contents'}
      allow(InputParser).to receive(:get_input).and_return(choice)
      player.play(board)
      expect(InputParser).to have_received(:get_input)
    end

    context "when the player chooses another option than making a move" do
      it "returns the given choice" do
        choice = {type: 'other', contents: 'contents'}
        allow(InputParser).to receive(:get_input).and_return(choice)
        expect(player.play(board)).to eql('contents')
      end
    end

    context "when the player wants to make a move" do
      context "when the move is valid" do
        let(:move) { { end_pos: [4,3], piece_type: 'pawn' } }
        let(:choice) { { type: 'move', contents: move } }
        let(:white_pawn) { instance_double(WhitePawn) }
        let(:new_board) { instance_double(Board) }

        before do
          allow(InputParser).to receive(:get_input).and_return(choice)
          allow(board).to receive(:get_pieces).with('pawn', 'white').and_return([white_pawn])
          allow(white_pawn).to receive(:can_move?).with(board, [4,3]).and_return(true)
          allow(white_pawn).to receive(:move).with(board, [4,3]).and_return(new_board)
        end
        
        it "tells the correct piece to move" do
          player.play(board)
          expect(white_pawn).to have_received(:move).with(board, [4,3])
        end

        it "returns the new board state returned by the piece" do
          expect(player.play(board)).to eql(new_board)
        end
      end

      context "when the move is not valid" do
        let(:bad_move) { { end_pos: [0,0], piece_type: 'pawn' } }
        let(:bad_choice) { { type: 'move', contents: bad_move } }
        let(:other_choice) { { type: 'other', contents: 'contents' } }
        let(:white_pawn) { instance_double(WhitePawn) }

        before do
          allow(InputParser).to receive(:get_input).and_return(bad_choice, other_choice)
          allow(board).to receive(:get_pieces).with('pawn', 'white').and_return([white_pawn])
          allow(white_pawn).to receive(:can_move?).with(board, [0,0]).and_return(false)
        end

        it "tells the player the chosen move was invalid" do
          expect{player.play(board)}.to output(
            "Not a valid move. Please try again:\n"
          ).to_stdout
        end

        it "asks the player for input again" do
          player.play(board)
          expect(InputParser).to have_received(:get_input).twice
        end
      end

      context "when there are several possible moves with the given input" do
        let(:move) { { end_pos: [2,2], piece_type: 'knight' } }
        let(:choice) { { type: 'move', contents: move } }
        let(:first_knight) { instance_double(Knight) }
        let(:second_knight) { instance_double(Knight) }
        let(:other_choice) { { type: 'other', contents: 'contents' } }
        
        before do
          allow(first_knight).to receive(:type).and_return('knight')
          allow(second_knight).to receive(:type).and_return('knight')
          allow(InputParser).to receive(:get_input).and_return(choice, other_choice)
          allow(board).to receive(:get_pieces).with('knight', 'white').and_return([first_knight, second_knight])
          allow(first_knight).to receive(:can_move?).with(board, [2,2]).and_return(true)
          allow(second_knight).to receive(:can_move?).with(board, [2,2]).and_return(true)
          allow(board).to receive(:get_position).with(first_knight).and_return([1,0])
          allow(board).to receive(:get_position).with(second_knight).and_return([4,1])
          allow(InputParser).to receive(:reverse_translate).with([1,0]).and_return('b1')
          allow(InputParser).to receive(:reverse_translate).with([4,1]).and_return('e2')
        end

        it "tells the player there are several possible moves and for each piece, asks the player whether they want to move it" do
          allow(player).to receive(:gets).and_return('n','y')
          allow(second_knight).to receive(:move)
          expect{player.play(board)}.to output(
            "More than one piece can make that move.\n" +
            "Do you want to move the knight that is currently at b1? Please answer (y/n)\n" +
            "Do you want to move the knight that is currently at e2? Please answer (y/n)\n"
          ).to_stdout
        end

        context "when the player provides invalid input" do          
          it "tells the player the input is invalid" do
            allow(player).to receive(:gets).and_return('test','y')
            allow(first_knight).to receive(:move)
            expect{player.play(board)}.to output(
              "More than one piece can make that move.\n" +
              "Do you want to move the knight that is currently at b1? Please answer (y/n)\n" +
              "Please type 'y' or 'n' to indicate whether you want to move the piece above.\n"
            ).to_stdout            
          end
        end
        
        context "when the player chooses a piece to move" do
          let(:new_board) { instance_double(Board) }

          before do
            allow(player).to receive(:gets).and_return('n','y')
            allow(second_knight).to receive(:move).with(board, [2,2]).and_return(new_board)
          end

          it "tells the correct piece to move" do
            player.play(board)
            expect(second_knight).to have_received(:move).with(board, [2,2])
          end

          it "returns the new board state returned by the piece" do
            expect(player.play(board)).to eql(new_board)
          end
        end

        context "when the player doesn't choose any of the pieces" do
          before do
            allow(player).to receive(:gets).and_return('n','n')
          end

          it "lets the player know they didn't make a choice" do
            expect{player.play(board)}.to output(
              "More than one piece can make that move.\n" +
              "Do you want to move the knight that is currently at b1? Please answer (y/n)\n" +
              "Do you want to move the knight that is currently at e2? Please answer (y/n)\n" +
              "You didn't make a choice. Please try again:\n"
            ).to_stdout
          end

          it "asks the player for input again" do
            player.play(board)
            expect(InputParser).to have_received(:get_input).twice
          end
        end
      end
    end
  end
end