require "./lib/connect_four.rb"

describe Grid do
    subject(:grid) { described_class.new }

    describe "#define_columns" do
        context "creates array for columns" do
            it "returns column 2" do
                array = grid.define_columns
                expect(array[1]).to eq([1, 8, 15, 22, 29, 36])
            end

            it "returns column 7" do
                array = grid.define_columns
                expect(array[6]).to eq([6, 13, 20, 27, 34, 41])
            end
        end
    end

    describe "#place_token" do
        context "inserts token when a column is picked from an empty board" do
            it "returns a token at the bottom of column 2" do
                grid.place_token(2)
                expect(grid.grid[36]).to eq("F")
            end
        end

        context "inserts token on top of another" do
            it "returns a token on top of another in column 5" do
                grid.grid[39] = "F"
                grid.place_token(5)
                expect(grid.grid[32]).to eq("F")
            end
        end
    end


end
