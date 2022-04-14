require "./lib/connect_four.rb"

describe Grid do
    subject(:grid) { described_class.new }

    describe "#define_columns" do
        context "creates array for columns" do
            it "return column 2" do
                array = grid.define_columns
                expect(array[1]).to eq([1, 8, 15, 22, 29, 36])
            end

            it "return column 7" do
                array = grid.define_columns
                expect(array[6]).to eq([6, 13, 20, 27, 34, 41])
            end
        end
    end


end
