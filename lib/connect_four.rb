class Grid
    attr_accessor :grid

    def initialize
        @grid = make_grid
        @left_border = define_single_column(0)
        @right_border = define_single_column(6)
    end

    def make_grid
        Array.new(42, " ")
    end

    def display_grid
        i = 0
        b = 0
        until i == 6 && b == 42
            print "| " + @grid.slice(b, 7).join(" | ").to_s + " |\n"
            # print " | " + @grid.slice(b, 7).map { | element | element.class.ancestors.include?(Token) ? element.symbol : element }.join(" | ").to_s + " |\n"
            print " ---+---+---+---+---+---+---\n"
            i += 1
            b += 7
        end
        print "  1   2   3   4   5   6   7\n"
    end

    def define_columns
        columns = Array.new
        k = 0
        until k == 7 do
            columns << define_single_column(k)
            k += 1
        end
        columns
    end
    
    def define_single_column(start)
        single_column = [start]
        5.times { single_column << single_column.last + 7 }
        single_column
    end

    def define_win_conditions_full
        win_conditions = Array.new

    end

    def define_win_conditions_vertical
        win_conditions = Array.new

    end

    def define_win_conditions_horizontal
        win_conditions = Array.new

    end

    def define_win_conditions_diagonal
        win_conditions = Array.new

    end

    def prune_border_crossing

    end

    def place_token(column)
        columns = define_columns
        target = columns[column - 1]
        target.reverse.each do | element |
            if self.grid[element] == " "
                self.grid[element] = "F"
                return
            end
        end
    end

end

class Game


    def make_players_dummy
        player_one = Player.new("Fran", "F")
        player_two = Player.new("Kolb", "K")
    end

    def make_players
        name_one, name_two = names_input
        symbol_one, symbol_two = symbols_input(name_one, name_two)
        player_one = Player.new(name_one, symbol_one)
        player_two = Player.new(name_two, symbol_two)
    end

    def names_input
        puts "Player 1, please type your name."
        name_one = gets.chomp 
        until !name_one.empty? do
            puts "Your name must not be blank."
            name_one = gets.chomp
        end
        puts "Player 2, please type your name."
        name_two = gets.chomp
        until !name_two.empty? && name_two != name_one do
            puts "Your name must not be blank or equal to player two's."
            name_two = gets.chomp
        end
        return name_one, name_two
    end

    def symbols_input(name_one, name_two)
        puts "#{name_one}, please type your symbol."
        symbol_one = gets.chomp
        until !symbol_one.empty? && symbol_one.length == 1 do
            puts "Your symbol must not be blank or longer than 1 character."
            symbol_one = gets.chomp
        end
        puts "#{name_two}, please type your symbol."
        symbol_two = gets.chomp
        until !symbol_two.empty? && symbol_two.length == 1 && symbol_two != symbol_one do
            puts "Your symbol must not be blank or longer than 1 character or equal to player two's."
            symbol_two = gets.chomp
        end
        return symbol_one, symbol_two
    end

end

class Player
    @@id = 1

    def initialize(name = nil, symbol = nil)
        @name = name
        @symbol = symbol
        @number = @@id
        @@id += 1
    end

end

class Token

    def initialize(symbol = nil)
        @symbol = symbol
    end

end


# board = Grid.new
# board.display_grid
# board.define_columns
# board.place_token(2)
# puts "STOP"