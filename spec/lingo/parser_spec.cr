require "../spec_helper"

describe "Lingo::Parser" do
  describe ".rule / rule methods" do
    it "exposes Rules" do
      plus_rule = math_parser.plus
      result = plus_rule.matches?("+")
      result.should eq(true)
    end
  end

  describe "#parse" do
    it "returns named results" do
      result = math_parser.parse("1+1")
      result.value.should eq("1+1")
      result.name.should eq(:expression)
    end
  end
end
