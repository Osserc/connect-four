module Grid_Navigation

    LEFT_BORDER = [0, 7, 14, 21, 28, 35]
    RIGHT_BORDER = [6, 13, 20, 27, 34, 41]

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
        win_conditions.concat(define_win_conditions_vertical).concat(define_win_conditions_horizontal).concat(define_win_conditions_diagonal_left).concat(define_win_conditions_diagonal_right)
    end

    def define_win_conditions_vertical
        win_conditions_vertical = Array.new
        k = 0
        until k > 20 do
            win_con = [k]
            3.times { win_con << win_con.last + 7}
            win_conditions_vertical << win_con
            k += 1
        end
        win_conditions_vertical
    end

    def define_win_conditions_horizontal
        win_conditions_horizontal = Array.new
        k = 0
        until k > 41 do
            win_con = [k]
            3.times { win_con << win_con.last + 1}
            win_conditions_horizontal << win_con
            k += 1
        end
        win_conditions_horizontal = prune_border_crossing_horizontal(win_conditions_horizontal)
    end

    def prune_border_crossing_horizontal(array)
        array.map! do | element |
            if RIGHT_BORDER.include?(element[0]) || RIGHT_BORDER.include?(element[1]) || RIGHT_BORDER.include?(element[2])
                element = nil
            else
                element
            end
        end
        array.compact!
    end

    def define_win_conditions_diagonal_right
        win_conditions_diagonal_right = Array.new
        k = 0
        until k > 17 do
            win_con = [k]
            3.times { win_con << win_con.last + 8}
            win_conditions_diagonal_right << win_con
            k += 1
        end
        win_conditions_diagonal_right = prune_border_crossing_diagonal(win_conditions_diagonal_right)
    end

    def define_win_conditions_diagonal_left
        win_conditions_diagonal_left = Array.new
        k = 0
        until k > 20 do
            win_con = [k]
            3.times { win_con << win_con.last + 6}
            win_conditions_diagonal_left << win_con
            k += 1
        end
        win_conditions_diagonal_left = prune_border_crossing_diagonal(win_conditions_diagonal_left)
    end

    def prune_border_crossing_diagonal(array)
        array.map! do | element |
            if RIGHT_BORDER.include?(element[1]) || RIGHT_BORDER.include?(element[2]) || LEFT_BORDER.include?(element[1]) || LEFT_BORDER.include?(element[2])
                element = nil
            else
                element
            end
        end
        array.compact!
    end

end

class Grid
    attr_accessor :grid
    include Grid_Navigation

    def initialize
        @grid = make_grid
    end

    def make_grid
        Array.new(42, " ")
    end

    def display_grid
        i = 0
        b = 0
        until i == 6 && b == 42
            print "| " + @grid.slice(b, 7).map { | element | element.class == Token ? element.symbol : element }.join(" | ").to_s + " |\n"
            print " ---+---+---+---+---+---+---\n"
            i += 1
            b += 7
        end
        print "  1   2   3   4   5   6   7\n"
    end

end

class Game
    include Grid_Navigation

    def start_game
        puts "Welcome, welcome! This is the famed, fabled, fabulous Connect Four! Match 4 of your own token either diagonally, horizontally or vertically to win! But beware of your opponent!"
        turn = 1
        grid = Grid.new
        win_cons = define_win_conditions_full
        player_one, player_two = make_players
        grid.display_grid
        loop do
            play_round(grid, turn, player_one, player_two)
            check_winner(grid, win_cons, turn, player_one, player_two)
            turn += 1
        end
    end

    def play_round(grid, turn, player_one, player_two)
        player_one.place_token(grid, choose_placement(grid, player_one)) if turn.odd?
        player_two.place_token(grid, choose_placement(grid, player_two)) if !turn.odd?
        grid.display_grid
    end

    # def make_players_dummy
    #     player_one = Player.new("Fran", "F")
    #     player_two = Player.new("Kolb", "K")
    #     return player_one, player_two
    # end

    def make_players
        name_one, name_two = names_input
        symbol_one, symbol_two = symbols_input(name_one, name_two)
        player_one = Player.new(name_one, symbol_one)
        player_two = Player.new(name_two, symbol_two)
        return player_one, player_two
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

    def choose_placement(grid, player)
        puts "#{player.name}, pick the column in which you want to place your token."
        col = gets.chomp.to_i
        until col >= 1 && col <= 7 && check_placement_validity(grid, col)
            puts "Invalid column."
            col = gets.chomp.to_i
        end
        col
    end

    def check_placement_validity(grid, col)
        empty = 0
        columns = define_columns
        columns[col - 1].each do | element |
            empty += 1 if grid.grid[element] == " "
        end
        empty > 0
    end

    def check_winner(grid, win_cons, turn, player_one, player_two)
        if turn < 42
            win_cons.each do | element |
                if check_tokens(grid, element, player_one, player_two) == 1
                    puts "#{player_one.name} won!"
                    restart_game
                elsif check_tokens(grid, element, player_one, player_two) == 2
                    puts "#{player_two.name} won!"
                    restart_game
                end
            end
        else
            puts "It's a tie!"
            restart_game
        end
    end

    def check_tokens(grid, win_con, player_one, player_two)
        tokens_one = 0
        tokens_two = 0
        win_con.each do | element |
            if grid.grid[element] != " "
                tokens_one += 1 if grid.grid[element].symbol == player_one.symbol
                tokens_two += 1 if grid.grid[element].symbol == player_two.symbol
            end
        end
        return 1 if tokens_one == 4
        return 2 if tokens_two == 4
    end

    def restart_game
        puts "Do you want to play another round? Enter yes or no."
        answer = gets.chomp.downcase
        until answer == "yes" || answer == "no" do
            puts "Please answer he question."
            answer = gets.chomp.downcase
        end
        Game.new.start_game if answer == "yes"
        exit if answer == "no"
    end

end

class Player
    attr_accessor :name, :symbol

    include Grid_Navigation

    def initialize(name = nil, symbol = nil)
        @name = name
        @symbol = symbol
    end

    def place_token(grid, column)
        columns = define_columns
        target = columns[column - 1]
        target.reverse.each do | element |
            if grid.grid[element] == " "
                grid.grid[element] = Token.new(self.symbol)
                return
            end
        end
    end

end

class Token
    attr_reader :symbol

    def initialize(symbol = nil)
        @symbol = symbol
    end

end


Game.new.start_game