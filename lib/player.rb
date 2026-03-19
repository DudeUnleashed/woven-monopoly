# stores player info

class Player 
    attr_reader :name, :money, :position

    STARTING_MONEY = 16

    def initialize(name)
            @name = name
            @money = STARTING_MONEY
            @position = 0
            @bankrupt = false
    end

    def move(spaces, board_size)
            old_position = @position
            @position = (@position + spaces) % board_size
            # passed go if new position is behind old position
            @position < old_position # returns true if passes go for game logic
    end

    def collect(amount)
            @money += amount
    end

    def pay(amount, recipient = nil)
            @money -= amount
            recipient.collect(amount) if recipient
            @bankrupt = true if @money < 0 # game continues when player has $0, but ends if in the negatives
    end

    def bankrupt?
            @bankrupt
    end
end