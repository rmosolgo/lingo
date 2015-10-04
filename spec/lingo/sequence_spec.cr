require "../spec_helper"

integer = Math.parser.integer
operator = Math.parser.binary_operator
binary_expression = integer.as(:operand) >> operator >> integer.as(:operand)

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
      child_names = result.children.map { |c| c.name }
      child_names.should eq([:operand, :plus, :operand])
    end
  end
end
