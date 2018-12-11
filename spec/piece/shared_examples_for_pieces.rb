shared_examples "a Piece" do
  it { is_expected.to respond_to(:colour) }
  it { is_expected.to respond_to(:type) }
  it { is_expected.to respond_to(:get_path) }
  it { is_expected.to respond_to(:square) }
  it { is_expected.to respond_to(:convert_path) }
end

shared_examples "a PieceSubclass" do
  it { is_expected.to respond_to(:post_initialize) }
  it { is_expected.to respond_to(:try_path) }
  it { is_expected.to respond_to(:directions) }
end