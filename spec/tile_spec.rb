require_relative '../lib/tile'

RSpec.describe Tile do
  describe "a property tile" do
    let(:tile) { Tile.new(name: "The Burvale", type: "property", price: 1, colour: "Brown") }

    it "is a property" do
      expect(tile).to be_property
    end

    it "starts unowned" do
      expect(tile).not_to be_owned
    end

    it "can be owned" do
      tile.owner = "Peter"
      expect(tile).to be_owned
    end

    it "stores its attributes" do
      expect(tile.name).to eq("The Burvale")
      expect(tile.price).to eq(1)
      expect(tile.colour).to eq("Brown")
    end
  end

  describe "the GO tile" do
    let(:tile) { Tile.new(name: "GO", type: "go") }

    it "is not a property" do
      expect(tile).not_to be_property
    end

    it "defaults price to 0" do
      expect(tile.price).to eq(0)
    end

    it "defaults colour to nil" do
      expect(tile.colour).to be_nil
    end
  end
end
