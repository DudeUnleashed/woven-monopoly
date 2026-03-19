# main game loop code

require_relative 'board'
require_relative 'player'
require_relative 'dice'

class Game
  attr_reader :players, :board

  PLAYER_NAMES = ["Peter", "Billy", "Charlotte", "Sweedal"].freeze
  GO_REWARD = 1

  def initialize(board_path, rolls_path, detailed: false)
    @board = Board.new(board_path)
    @dice = Dice.new(rolls_path)
    @players = PLAYER_NAMES.map { |name| Player.new(name) }
    @current_player_index = 0
    @detailed = detailed
  end

  def play
    round = 1
    while @dice.rolls_remaining?
      player = current_player
      roll = @dice.next_roll
      old_tile = @board.tile_at(player.position)

      passed_go = player.move(roll, @board.size) # player.move returns a bool if the players new position is behind the old, therefore passing go
      player.collect(GO_REWARD) if passed_go

      tile = @board.tile_at(player.position)
      action = handle_landing(player, tile)

      if @detailed # handles the bulk of the detailed message dialogue
        msg = "#{player.name} rolls a #{roll} and moves from #{old_tile.name} to #{tile.name}"
        msg += ", passes GO and collects $#{GO_REWARD}" if passed_go
        msg += ", #{action}" if action
        msg += " (#{player.name} has $#{player.money} remaining)"
        puts "[Turn #{round}] #{msg}"
      end

      if player.bankrupt?
        puts "[Turn #{round}] #{player.name} is bankrupt!" if @detailed
        break # game ends as soon as someone is bankrupt
      end

      @current_player_index = (@current_player_index + 1) % @players.length
      round += 1
    end
  end

  def winner
    @players.max_by(&:money) # winner is determined by player with most money when game ends
  end

  def print_results
    puts ""
    puts "=== Game Results ==="
    puts "Winner: #{winner.name}"
    puts ""
    @players.each do |player|
      tile = @board.tile_at(player.position)
      puts "#{player.name}:"
      puts "  Money: $#{player.money}"
      puts "  Final space: #{tile.name}"
      puts "  Bankrupt: #{player.bankrupt?}"
      puts ""
    end
  end

  private

  def current_player
    @players[@current_player_index]
  end

  def handle_landing(player, tile)
    return nil unless tile.property? # skips logic if tile is go

    if tile.owned?
      rent = tile.price
      if @board.all_colour_owned_by?(tile.colour, tile.owner) # is the check to see if the owner has all the colour spaces and doubles rent
        rent *= 2
        pays_msg = "pays $#{rent} rent (doubled) to #{tile.owner.name}"
      else
        pays_msg = "pays $#{rent} rent to #{tile.owner.name}"
      end
      player.pay(rent, tile.owner)
      pays_msg
    else
      player.pay(tile.price) # forces the player to buy the property if landed on and not owned already
      tile.owner = player
      "buys #{tile.name} for $#{tile.price}"
    end
  end
end
