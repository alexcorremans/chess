require './lib/inputparser'

describe InputParser do
  before do
    allow($stdout).to receive(:write)
  end

  describe "#get_input" do    
    it "asks the player to enter a move or to type 'help' for instructions" do
      allow(subject).to receive(:gets).and_return('pawn to e4')
      expect{subject.get_input}.to output(
        "Please enter your move or type 'help' for more instructions:\n"
      ).to_stdout
    end

    it "asks the player for input" do
      allow(subject).to receive(:gets).and_return('pawn to e4')
      subject.get_input
      expect(subject).to have_received(:gets).once
    end

    context "when the player chooses one of the options" do
      context "when the player types 'help'" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return('help')
          result = { type: 'other', contents: 'help' }
          expect(subject.get_input).to eql(result)
        end
      end

      context "when the player types 'save'" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return('save')
          result = { type: 'other', contents: 'save' }
          expect(subject.get_input).to eql(result)
        end
      end

      context "when the player types 'quit'" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return('quit')
          result = { type: 'other', contents: 'quit' }
          expect(subject.get_input).to eql(result)
        end
      end

      context "when the player types 'resign'" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return('resign')
          result = { type: 'other', contents: 'resign' }
          expect(subject.get_input).to eql(result)
        end
      end
    end

    context "when the player enters a move" do
      context "when the player types 'queen to e4'" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return('queen to e4')
          move = { end_pos: [4,3], piece_type: 'queen' }
          result = { type: 'move', contents: move }
          expect(subject.get_input).to eql(result)
        end
      end

      context "when the player types ' king a1'" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return(' king a1')
          move = { end_pos: [0,0], piece_type: 'king' }
          result = { type: 'move', contents: move }
          expect(subject.get_input).to eql(result)
        end
      end

      context "when the player types 'C3 '" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return('C3 ')
          move = { end_pos: [2,2], piece_type: 'pawn' }
          result = { type: 'move', contents: move }
          expect(subject.get_input).to eql(result)
        end
      end

      context "when the player types 'knight to b 5'" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return('knight to b 5')
          move = { end_pos: [1,4], piece_type: 'knight' }
          result = { type: 'move', contents: move }
          expect(subject.get_input).to eql(result)
        end
      end

      context "when the player types ' E 4 Rook '" do
        it "returns the correct choice" do
          allow(subject).to receive(:gets).and_return(' E 4 Rook ')
          move = { end_pos: [4,3], piece_type: 'rook' }
          result = { type: 'move', contents: move }
          expect(subject.get_input).to eql(result)
        end
      end
    end

    context "when the player enters invalid input" do
      context "when the player types 'xcmfhzamzlrehz'" do
        it "tells the player the input is invalid" do
          allow(subject).to receive(:gets).and_return('xcmfhzamzlrehz', 'help')
          expect{subject.get_input}.to output(
            "Please enter your move or type 'help' for more instructions:\n" +
            "Invalid input, please try again or type 'help' if you don't know what to do:\n"
          ).to_stdout
        end

        it "asks the player for input again" do
          allow(subject).to receive(:gets).and_return('xcmfhzamzlrehz', 'help')
          subject.get_input
          expect(subject).to have_received(:gets).twice
        end
      end

      context "when the player types 'bishop to Z3'" do
        it "tells the player the input is invalid" do
          allow(subject).to receive(:gets).and_return('bishop to Z3', 'quit')
          expect{subject.get_input}.to output(
            "Please enter your move or type 'help' for more instructions:\n" +
            "Invalid input, please try again or type 'help' if you don't know what to do:\n"
          ).to_stdout
        end

        it "asks the player for input again" do
          allow(subject).to receive(:gets).and_return('bishop to Z3', 'quit')
          subject.get_input
          expect(subject).to have_received(:gets).twice
        end
      end

      context "when the player types 'pawn to b9'" do
        it "tells the player the input is invalid" do
          allow(subject).to receive(:gets).and_return('pawn to b9', 'pawn to b8')
          expect{subject.get_input}.to output(
            "Please enter your move or type 'help' for more instructions:\n" +
            "Invalid input, please try again or type 'help' if you don't know what to do:\n"
          ).to_stdout
        end

        it "asks the player for input again" do
          allow(subject).to receive(:gets).and_return('pawn to b9', 'pawn to b8')
          subject.get_input
          expect(subject).to have_received(:gets).twice
        end
      end
    end
  end

  describe "#choose_piece(piece_type, coordinates)" do
    it "asks the player whether they want to move the given piece" do
      allow(subject).to receive(:gets).and_return('y')
      expect{subject.choose_piece('knight',[1,0])}.to output(
        "Do you want to move the knight that is currently at b1? Please answer (y/n)\n"
      ).to_stdout
    end

    it "asks the player for input" do
      allow(subject).to receive(:gets).and_return('y')
      subject.choose_piece('knight',[1,0])
      expect(subject).to have_received(:gets).once
    end

    context "when the player types 'y'" do
      it "returns the correct result" do
        allow(subject).to receive(:gets).and_return('y')
        expect(subject.choose_piece('knight',[1,0])).to eql('y')
      end
    end

    context "when the player types 'n'" do
      it "returns the correct result" do
        allow(subject).to receive(:gets).and_return('n')
        expect(subject.choose_piece('knight',[1,0])).to eql('n')
      end
    end

    context "when the player provides invalid input" do
      it "tells the player the input is invalid" do
        allow(subject).to receive(:gets).and_return('mlerhezmrl', 'n')
        expect{subject.choose_piece('knight',[1,0])}.to output(
          "Do you want to move the knight that is currently at b1? Please answer (y/n)\n" +
          "Please type 'y' or 'n' to indicate whether you want to move the piece above.\n"
        ).to_stdout
      end

      it "asks the player for input again" do
        allow(subject).to receive(:gets).and_return('clmhrezh', 'y')
        subject.choose_piece('knight', [1,0])
        expect(subject).to have_received(:gets).twice
      end
    end
  end
end