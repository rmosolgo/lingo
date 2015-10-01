require "../spec_helper"

describe "Lingo::Parser" do
  describe ".rule / rule methods" do
    it "exposes Rules" do
      plus_rule = math_parser.plus
      result = plus_rule.parse("+")
      result.rule_name.should eq(:plus)
    end
  end

  describe "#parse" do
    it "returns named results" do
      result = math_parser.parse("1+1")
      result.children.size.should eq(3)
      result.rule_name.should eq(:expression)
    end
  end
end
