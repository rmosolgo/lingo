require "../spec_helper"

describe "Lingo::Parser" do
  describe ".rule / rule methods" do
    it "exposes Rules" do
      plus_rule = Math.parser.plus
      result = plus_rule.parse("+")
      result.should be_a(Lingo::Node)
    end
  end

  describe "#parse" do
    it "returns named results" do
      result = Math.parser.parse("1+1")
      result.name.should eq(:expression)
    end
  end
end
