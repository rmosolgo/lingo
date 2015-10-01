require "../spec_helper"

describe "Lingo::Sequence" do
  describe "#matches?" do
    it "only matches if all parts match" do
      expression = math_parser.expression
      expression.inner.should be_a(Lingo::Sequence)

      expression.matches?("1+1").should eq(true)
      expression.matches?("1+12321").should eq(true)

      expression.matches?("1+").should eq(false)
      expression.matches?("+1").should eq(false)
    end
  end

  describe "#parse" do
    it "returns children in the sequence" do
      expression = math_parser.expression
      result = expression.parse("1+1")
      result.children.first.children.size.should eq(3)
    end
  end
end
