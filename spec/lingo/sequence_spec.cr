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
    pending "returns something meaningful" do
    end
  end
end
