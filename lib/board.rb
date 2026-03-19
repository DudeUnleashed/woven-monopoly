# loads board.json and handles boardstate

require 'json'
require_relative 'tile'

class Board
    attr_reader :tiles

    def initialize(file_path)
            data = JSON.parse(File.read(file_path))
            @tiles = data.map do |tile_data|
                            Tile.new(
                              name: tile_data["name"],
                              type: tile_data["type"],
                              price: tile_data["price"] || 0,
                              colour: tile_data["colour"]
                            )
            end
    end

    def size
      @tiles.length
    end

    def tile_at(position)
            @tiles[position]
    end

    def all_colour_owned_by?(colour, player)
            @tiles.select { |t| t.colour == colour }
                  .all? { |t| t.owner == player }
    end
end