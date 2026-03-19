# main file to create the game and play within the cli

require_relative 'lib/game'

ROLLS_FILES = {
  "rolls1" => "data/rolls_1.json",
  "rolls2" => "data/rolls_2.json"
}.freeze

BOARD_FILE = "data/board.json"

if ARGV.empty? || !ROLLS_FILES.key?(ARGV[0]) # writes usage guidelines if input is just 'ruby main.rb', or an incorrect argument
  puts "Usage: ruby main.rb <rolls1|rolls2>"
  puts "  rolls1 - simulate game with first set of dice rolls"
  puts "  rolls2 - simulate game with second set of dice rolls"
  puts "  --detailed - print a description of each turn in the game"
  exit 1
end

detailed = ARGV.include?("--detailed")

game = Game.new(BOARD_FILE, ROLLS_FILES[ARGV[0]], detailed: detailed)
game.play
game.print_results
