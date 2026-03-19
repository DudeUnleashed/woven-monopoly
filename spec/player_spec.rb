require_relative "../lib/player"

RSpec.describe Player do
  let(:player) { Player.new("Peter") }

  it "starts with $16" do
    expect(player.money).to eq(16)
  end

  it "starts at position 0" do
    expect(player.position).to eq(0)
  end

  it "starts not bankrupt" do
    expect(player).not_to be_bankrupt
  end

  describe "#move" do
    it "updates position" do
      player.move(3, 9)
      expect(player.position).to eq(3)
    end

    it "wraps around the board" do
      player.move(10, 9)
      expect(player.position).to eq(1)
    end

    it "returns true when passing GO" do
      player.move(5, 9) # move off of go first
      expect(player.move(6, 9)).to be true # passes go
    end

    it "returns false when not passing GO" do
      expect(player.move(3, 9)).to be false
    end
  end

  describe "#collect" do
    it "adds money" do
      player.collect(5)
      expect(player.money).to eq(21)
    end
  end

  describe "#pay" do
    it "subtracts money" do
      player.pay(5)
      expect(player.money).to eq(11)
    end

    it "transfers money to recipient" do
      recipient = Player.new("Billy")
      player.pay(5, recipient)
      expect(recipient.money).to eq(21)
    end

    it "is not bankrupt at $0" do
      player.pay(16)
      expect(player).not_to be_bankrupt
    end

    it "is bankrupt below $0" do
      player.pay(17)
      expect(player).to be_bankrupt
    end
  end
end
