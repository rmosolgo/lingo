require "../spec_helper"

integer = Math.parser.integer
operator = Math.parser.operator
binary_expression = integer.named(:operand) >> operator >> integer.named(:operand)

describe "Lingo::Sequence" do
  describe "#matches?" do
    it "only matches if all parts match" do
      binary_expression.should be_a(Lingo::Sequence)

      binary_expression.matches?("1+1").should eq(true)
      binary_expression.matches?("1+12321").should eq(true)

      binary_expression.matches?("1+").should eq(false)
      binary_expression.matches?("+1").should eq(false)
    end
  end

  describe "#parse" do
    it "returns children in the sequence" do
      result = binary_expression.parse("-15+1")
      result.children.size.should eq(3)
      child_names = result.children.map &.name
      child_names.should eq([:operand, :plus, :operand])
      result.line.should eq(1)
      result.column.should eq(1)
      child_columns = result.children.map &.column
      child_columns.should eq([1, 4, 5])
    end
  end
end
