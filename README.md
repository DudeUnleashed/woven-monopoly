# Woven Monopoly

A Ruby CLI application that simulates a deterministic game of Monopoly using pre-defined dice rolls.

## Setup

```bash
git clone https://github.com/DudeUnleashed/woven-monopoly.git
bundle install
```

## Usage

```bash
ruby main.rb rolls1              # simulate game with first set of dice rolls
ruby main.rb rolls2              # simulate game with second set of dice rolls
ruby main.rb rolls1 --detailed   # include turn-by-turn descriptions
```

## Running Tests

```bash
bundle exec rspec
```

## Design

The application is split into small, single-responsibility classes:

- **Tile** — represents a board space (property or GO)
- **Player** — tracks name, money, position, and bankruptcy
- **Dice** — reads and serves pre-defined rolls from JSON
- **Board** — loads tiles from JSON, handles position lookup and colour ownership checks
- **Game** — orchestrates the game loop, applying rules each turn
