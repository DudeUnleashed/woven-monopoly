require_relative '../lib/board'

RSpec.describe Board do
  let(:board) { Board.new("data/board.json") }

  it "loads all tiles" do
    expect(board.size).to eq(9)
  end

  it "has GO as the first tile" do
    expect(board.tile_at(0).name).to eq("GO")
    expect(board.tile_at(0).type).to eq("go")
  end

  it "loads property tiles with correct attributes" do
    tile = board.tile_at(1)
    expect(tile.name).to eq("The Burvale")
    expect(tile.price).to eq(1)
    expect(tile.colour).to eq("Brown")
  end

  describe "#all_colour_owned_by?" do
    it "returns false when no properties are owned" do
      expect(board.all_colour_owned_by?("Brown", "Peter")).to be false
    end

    it "returns false when only some properties of a colour are owned" do
      board.tile_at(1).owner = "Peter"
      expect(board.all_colour_owned_by?("Brown", "Peter")).to be false
    end

    it "returns true when all properties of a colour are owned by the same player" do
      board.tile_at(1).owner = "Peter"
      board.tile_at(2).owner = "Peter"
      expect(board.all_colour_owned_by?("Brown", "Peter")).to be true
    end

    it "returns false when properties are owned by different players" do
      board.tile_at(1).owner = "Peter"
      board.tile_at(2).owner = "Billy"
      expect(board.all_colour_owned_by?("Brown", "Peter")).to be false
    end
  end
end