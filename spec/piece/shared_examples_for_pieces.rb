shared_examples "a Piece" do
  it { is_expected.to respond_to(:colour) }
  it { is_expected.to respond_to(:type) }
  it { is_expected.to respond_to(:can_move?) }
  it { is_expected.to respond_to(:move_allowed?) }
  it { is_expected.to respond_to(:no_check?) }
  it { is_expected.to respond_to(:move) }
  it { is_expected.to respond_to(:moved?) }
  it { is_expected.to respond_to(:set_moved) }
  it { is_expected.to respond_to(:get_path) }
  it { is_expected.to respond_to(:square) }
  it { is_expected.to respond_to(:create_move) }
  it { is_expected.to respond_to(:convert_path) }
  it { is_expected.to respond_to(:special_moves?) }
end

shared_examples "a PieceSubclass" do
  it { is_expected.to respond_to(:try_path) }
  it { is_expected.to respond_to(:directions) }
  it { is_expected.to respond_to(:post_initialize) }
  it { is_expected.to respond_to(:special_moves) }
  it { is_expected.to respond_to(:get_special_move) }
end