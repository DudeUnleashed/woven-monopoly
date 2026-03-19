# stores and acts on tile data.

class Tile 
    attr_reader :name, :type, :price, :colour
    attr_accessor :owner

    def initialize(name:, type:, price: 0, colour: nil)
            @name = name
            @type = type
            @price = price
            @colour = colour
            @owner = nil
    end

    def property? # a check for go to skip the purchase/rent stage
            type == "property"
    end

    def owned?
            !owner.nil?
    end
end