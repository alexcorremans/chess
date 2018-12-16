require './lib/player'

fdescribe Player do


  describe "#play" do
    let(:player) { Player.new(team: 'white', name: 'tester') }
    let(:board) { instance_double(Board) }

    context "when the player doesn't want to make a move" do
      let(:choice) { {type: 'other', contents: 'contents'} }
      
      before do
        allow(player).to receive(:get_input).and_return(choice)
      end
      it "returns the given choice" do
        expect(player.play(board)).to eql('contents')
      end
    end

    context "when the player wants to make a move" do
      

    end


  end
end