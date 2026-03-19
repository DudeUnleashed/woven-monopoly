require_relative '../lib/dice'

RSpec.describe Dice do
  let(:dice) { Dice.new("data/rolls_1.json") }

  it "loads rolls from JSON" do
    expect(dice.rolls).to be_an(Array)
    expect(dice.rolls).not_to be_empty
  end

  it "serves rolls in order" do
    first = dice.rolls[0]
    second = dice.rolls[1]
    expect(dice.next_roll).to eq(first)
    expect(dice.next_roll).to eq(second)
  end

  it "tracks remaining rolls" do
    expect(dice).to be_rolls_remaining
    dice.rolls.length.times { dice.next_roll }
    expect(dice).not_to be_rolls_remaining
  end
end
