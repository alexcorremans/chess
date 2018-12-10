require './lib/square'

describe Square do
  describe "#coordinates" do
    it "returns the square's x and y coordinates as an array" do
      square = Square.new(x: 5, y: 4)
      expect(square.coordinates).to eql([5,4])
    end
  end

  describe "#empty?" do
    it "returns true if the contents of the square are nil" do
      square = Square.new(x: 5, y: 4)
      expect(square.empty?).to be true
    end

    it "returns false if the contents of the square are not nil" do
      square = Square.new(x: 5, y:4, contents: "some piece")
      expect(square.empty?).to be false
    end
  end

  describe "#add(piece)" do
    it "sets the contents of the square to the given piece" do
      square = Square.new(x: 5, y:4)
      square.add("a chess piece")
      expect(square.contents).to eql("a chess piece")
    end
  end

  describe "#empty" do
    it "empties the contents of the square" do
      square = Square.new(x:5, y:4, contents: "a chess piece")
      square.empty
      expect(square.contents).to be nil
    end
  end

  describe "#generate_child(step)" do

    let(:square) { Square.new(x:5, y:4) }

    it "returns a child Square object" do
      child = square.generate_child([0,0])
      expect(child).to be_an_instance_of(Square)
    end

    it "sets the child square's parent to the square on which the method was called" do
      child = square.generate_child([0,0])
      expect(child.parent).to eql(square)
    end

    it "sets the child square's coordinates to the sum of the original square's coordinates and the ones contained in a given two-element array" do
      child = square.generate_child([2,1])
      expect(child.x).to eql(7)
      expect(child.y).to eql(5)
    end

    it "returns nil if the sum of the x coordinates is not between 0 and 7 (the board's boundaries)" do
      child = square.generate_child([3,0])
      expect(child).to be nil
    end

    it "returns nil if the sum of the y coordinates is not between 0 and 7 (the board's boundaries)" do
      child = square.generate_child([0,-5])
      expect(child).to be nil
    end
  end
end