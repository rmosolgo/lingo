require "../spec_helper"

SIXES_TERMINAL = Lingo::Terminal.new("66")
SEVENS_TERMINAL = Lingo::Terminal.new("77")
EIGHTS_TERMINAL = Lingo::Terminal.new("88")
SEVENS_EIGHTS = Lingo::OrderedChoice.new(SEVENS_TERMINAL, EIGHTS_TERMINAL)
SIXES_SEVENS_EIGHTS = Lingo::OrderedChoice.new(SIXES_TERMINAL, SEVENS_EIGHTS)

describe "Lingo::OrderedChoice" do
  describe "#matches?" do
    it "tries to match the first one, then falls back to the second" do
      digit = math_parser.digit
      plus = math_parser.plus
      d_or_p = digit | plus
      d_or_p.matches?("00+").should eq(true)
      d_or_p.matches?("+1").should eq(true)
      d_or_p.matches?("99").should eq(false)
    end
  end

  describe "#parse" do
    it "applies the first successful parse" do
      digit = math_parser.digit
      plus = math_parser.plus
      d_or_p = (digit | plus).as(:d_or_p)

      result = d_or_p.parse("+1")
      result.value.should eq("+")

      result = d_or_p.parse("1+1")
      result.value.should eq("1")
    end
  end
end
