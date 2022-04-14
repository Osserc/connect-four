class Grid
    attr_accessor :grid

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
            print "| " + @grid.slice(b, 7).join(" | ").to_s + " |\n"
            # print " | " + @grid.slice(b, 8).map { | element | element.class.ancestors.include?(Token) ? element.symbol : element }.join(" | ").to_s + " |\n"
            print " ---+---+---+---+---+---+---\n"
            i += 1
            b += 7
        end
        print "  1   2   3   4   5   6   7\n"
    end

end

grid = Grid.new.display_grid