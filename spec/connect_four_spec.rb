require "./lib/connect_four.rb"

describe Grid do
    subject(:board) { described_class.new }

    describe "#define_columns" do
        context "creates array for columns" do
            it "returns column 2" do
                array = board.define_columns
                expect(array[1]).to eq([1, 8, 15, 22, 29, 36])
            end

            it "returns column 7" do
                array = board.define_columns
                expect(array[6]).to eq([6, 13, 20, 27, 34, 41])
            end
        end
    end

end

describe Player do
    subject(:player) { described_class.new("Fran", "F") }
    


    describe "#place_token" do
        context "inserts token when a column is picked from an empty board" do
            before do
                board = class_double("Grid").as_stubbed_const
            end

            it "returns a token at the bottom of column 2" do
                player.place_token(board, 2)
                expect(board.grid[36]).to eq("F")
            end
        end

        context "inserts token on top of another" do
            before do
                board = class_double("Grid").as_stubbed_const
            end

            it "returns a token on top of another in column 5" do
                board.grid[39] = "F"
                player.place_token(board, 5)
                expect(board.grid[32]).to eq("F")
            end
        end
    end

end