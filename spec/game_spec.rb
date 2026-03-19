require_relative '../lib/game'

RSpec.describe Game do
  let(:game) { Game.new("data/board.json", "data/rolls_1.json") }

  it "creates four players" do
    expect(game.players.length).to eq(4)
  end

  it "creates players in the correct order" do
    names = game.players.map(&:name)
    expect(names).to eq(["Peter", "Billy", "Charlotte", "Sweedal"])
  end

  it "starts all players with $16" do
    game.players.each do |player|
      expect(player.money).to eq(16)
    end
  end

  it "loads the board" do
    expect(game.board.size).to eq(9)
  end

  describe "#play" do
    before { game.play }

    it "ends with a bankrupt player or no rolls remaining" do
      has_bankrupt = game.players.any?(&:bankrupt?)
      expect(has_bankrupt).to be true
    end

    it "determines a winner" do
      expect(game.winner).not_to be_nil
      expect(game.winner.name).to be_a(String)
    end

    it "winner is not bankrupt" do
      expect(game.winner).not_to be_bankrupt
    end
  end

  describe "with different roll sets" do
    let(:game2) { Game.new("data/board.json", "data/rolls_2.json") }

    it "can simulate both roll files" do
      game.play
      game2.play
      expect(game.winner.name).to be_a(String)
      expect(game2.winner.name).to be_a(String)
    end
  end
end