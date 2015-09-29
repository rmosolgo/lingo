require "../spec_helper"

def math_parser
  MathParser.new
end

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
      result = math_parser.parse("1+1") as Lingo::Terminal::ParseResult
      result.match.should eq("+")
      result.name.should eq(:plus)
    end
  end
end
