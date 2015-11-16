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
      result = Math.parser.parse("1+1+3")
      result.name.should eq(:expression)
    end

    describe "on errors" do
      it "tells how far it got" do
        expect_raises(Lingo::ParseFailedException, "at 3:15") do
          Math.parser.parse("1
          +
          3 + 3%%")
        end
      end

      it "tells the nearby string" do
        expect_raises(Lingo::ParseFailedException, "%%%") do
          Math.parser.parse("1+%%%")
        end
      end
    end
  end

  describe ".instance" do
    it "memoizes an instance" do
      Math::Parser.instance.should eq(Math::Parser.instance)
    end
  end
end
