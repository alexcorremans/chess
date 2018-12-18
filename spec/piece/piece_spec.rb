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

class PieceSpecialDouble < Piece
  def try_path(a,b,direction)
    nil
  end

  def directions
    ['some direction']
  end

  def special_moves
    ['special move']
  end

  def get_special_move(a,b)
    if a == [0,0] && b == [2,0]
      path = [[0,0],[1,0],[2,0]]
      return create_move(self, path, 'special')
    else
      return nil
    end
  end
end

describe PieceSpecialDouble do
  let(:subject) { PieceSpecialDouble.new('white') }

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
  let(:special_double) { PieceSpecialDouble.new('white') }
  let(:board) { instance_double(Board) }
  
  before { allow(board).to receive(:get_position).and_return([0,0]) }

  describe "#can_move?(board, end_pos)" do
    context "when the endpoint is the same as the piece's current position" do
      it "returns false" do
        expect(double.can_move?(board, [0,0])).to be false
      end
    end

    context "when the endpoint is somewhere the piece can normally go" do
      context "when the current board state doesn't allow the piece to go there" do
        it "returns false" do
          allow(board).to receive(:move_ok?).and_return(false)
          expect(double.can_move?(board, [0,1])).to be false
        end
      end

      context "when the current board state allows the piece to go there" do
        context "when the move puts the player in check" do
          it "returns false" do
            allow(board).to receive(:move_ok?).and_return(true)
            allow(board).to receive(:move_causes_check?).and_return(true)
            expect(double.can_move?(board, [0,1])).to be false  
          end
        end

        context "when the move doesn't put the player in check" do
          it "returns true" do
            allow(board).to receive(:move_ok?).and_return(true)
            allow(board).to receive(:move_causes_check?).and_return(false)
            expect(double.can_move?(board, [0,1])).to be true
          end
        end
      end
    end

    context "when the endpoint is somewhere the piece can't normally go" do
      context "when the piece has special moves" do
        context "when the requested move is one of the piece's special moves" do
          context "when the board doesn't allow it" do
            it "returns false" do
              allow(board).to receive(:move_ok?).and_return(false)
              expect(special_double.can_move?(board, [2,0])).to be false
            end
          end

          context "when the board allows it" do
            context "when the move puts the player in check" do
              it "returns false" do
                allow(board).to receive(:move_ok?).and_return(true)
                allow(board).to receive(:move_causes_check?).and_return(true)
                expect(special_double.can_move?(board, [2,0])).to be false
              end
            end

            context "when the move doesn't put the player in check" do
              it "returns true" do
                allow(board).to receive(:move_ok?).and_return(true)
                allow(board).to receive(:move_causes_check?).and_return(false)
                expect(special_double.can_move?(board, [2,0])).to be true
              end
            end
          end
        end
      
        context "when the requested move is not one of the piece's special moves" do
          it "returns false" do
            expect(special_double.can_move?(board, [2,1])).to be false
          end
        end
      end

      context "when the piece has no special moves" do
        it "returns false" do
          expect(double.can_move?(board, [2,0])).to be false
        end
      end      
    end
  end

  describe "#move(board, end_pos)" do
    context "when the endpoint is somewhere the piece can normally go" do
      it "sends #update to the board" do
        allow(board).to receive(:update)
        double.move(board, [0,1])
        expect(board).to have_received(:update)
      end
      
      it "returns the new board state" do
        allow(board).to receive(:update).and_return('new board')
        expect(double.move(board, [0,1])).to eql('new board')
      end
    end

    context "when the endpoint is somewhere the piece can't normally go" do
      it "sends #update to the board" do
        allow(board).to receive(:update)
        special_double.move(board, [2,0])
        expect(board).to have_received(:update)
      end

      it "returns the new board state" do
        allow(board).to receive(:update).and_return('new board')
        expect(special_double.move(board, [2,0])).to eql('new board')
      end
    end    
  end

  describe "#moved?" do
    it "returns false when the piece hasn't moved before" do
      expect(double.moved?).to be false
    end

    it "returns true when the piece has moved before" do
      double.instance_variable_set(:@moved, true)
      expect(double.moved?).to be true
    end
  end

  describe "#set_moved" do
    it "changes the @moved variable to true" do
      double.set_moved
      expect(double.moved?).to be true
    end

    it "returns the modified piece" do
      new_piece = double.set_moved
      expect(new_piece).to eql(double)
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