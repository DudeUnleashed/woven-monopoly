# reads rolls.json and serves the data to the game

require 'json'

class Dice
  attr_reader :rolls

  def initialize(file_path)
    @rolls = JSON.parse(File.read(file_path))
    @current = 0
  end

  def next_roll
    roll = @rolls[@current]
    @current += 1
    roll
  end

  def rolls_remaining?
    @current < @rolls.length
  end
end
