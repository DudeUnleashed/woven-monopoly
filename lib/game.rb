# main game loop code

require_relative 'board'
require_relative 'player'
require_relative 'dice'

class Game
    attr_reader :players, :board

    PLAYER_NAMES = ["Peter", "Billy", "Charlotte", "Sweedal"].freeze
    GO_REWARD = 1

    def initialize(board_path, rolls_path)
            @board = Board.new(board_path)
            @dice = Dice.new(rolls_path)
            @players = PLAYER_NAMES.map { |name| Player.new(name) }
            @current_player_index = 0
    end

    def play
            while @dice.rolls_remaining?
                            player = current_player
                            roll = @dice.next_roll

                            passed_go = player.move(roll, @board.size)
                            player.collect(GO_REWARD) if passed_go

                            tile = @board.tile_at(player.position)
                            handle_landing(player, tile)

                            break if player.bankrupt?
                            
                            @current_player_index = (@current_player_index + 1) % @players.length
            end
    end

    def winner
            @players.max_by(&:money) # winner is determined by player with most money when game ends
    end

    def print_results
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
            return unless tile.property? # skips logic if tile is go

            if tile.owned?
                            rent = tile.price
                            rent *= 2 if @board.all_colour_owned_by?(tile.colour, tile.owner)
                            player.pay(rent, tile.owner)
            else
              player.pay(tile.price)
              tile.owner = player
            end
    end
end