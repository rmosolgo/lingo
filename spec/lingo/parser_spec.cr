require "../spec_helper"

describe "Lingo::Parser" do
  describe ".rule / rule methods" do
    it "exposes Rules" do
      plus_rule = math_parser.plus
      result = plus_rule.parse("+")
      result.name.should eq(:plus)
    end
  end

  describe "#parse" do
    it "returns named results" do
      result = math_parser.parse("1+1")
      result.name.should eq(:expression)
    end
  end
end
