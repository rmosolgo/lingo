require "../spec_helper"

describe "Lingo::Sequence" do
  describe "#matches?" do
    it "only matches if all parts match" do
      expression = math_parser.expression
      expression.should be_a(Lingo::Sequence)

      expression.matches?("1+1").should eq(true)
      expression.matches?("1+12321").should eq(true)

      expression.matches?("1+").should eq(false)
      expression.matches?("+1").should eq(false)
    end
  end

  describe "#parse" do
    it "returns children in the sequence" do
      expression = math_parser.expression
      result = expression.parse("15+1")
      child_names = result.children.map {|c| c.name }
      puts child_names
      result.children.size.should eq(3)
      child_names.should eq([:operand, :plus, :operand])
    end
  end
end
