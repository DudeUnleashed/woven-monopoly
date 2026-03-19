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

  describe "#handle_landing on own property" do
    it "does not charge you when landing on own property" do
      game.play
      owner = game.players.find { |p| game.board.tiles.any? { |t| t.owner == p } } # finds a player that owns a tile
      tile = game.board.tiles.find { |t| t.owner == owner } # finds a tile that the owner owns
      money_before = owner.money
      game.send(:handle_landing, owner, tile) # simulates player landing on their own space
      expect(owner.money).to eq(money_before)
    end
  end

  describe "game ends when rolls run out instead of bankruptcy" do
    it "finishes without bankruptcy if rolls run out" do
      require 'json'
      require 'tempfile'

      # creates a shorter game with the first 8 rolls from rolls_1.json where the game wont end in bankruptcy
      rolls = JSON.parse(File.read("data/rolls_1.json")).first(8)
      temp = Tempfile.new(['short_rolls', '.json'])
      temp.write(rolls.to_json)
      temp.close

      short_game = Game.new("data/board.json", temp.path)
      short_game.play

      expect(short_game.players.none?(&:bankrupt?)).to be true
      expect(short_game.winner).not_to be_nil

      temp.unlink
    end
  end
end
