require "../spec_helper"

SIXES_TERMINAL = Lingo::Terminal.new("66")
SEVENS_TERMINAL = Lingo::Terminal.new("77")
EIGHTS_TERMINAL = Lingo::Terminal.new("88")
SEVENS_EIGHTS = Lingo::OrderedChoice.new(SEVENS_TERMINAL, EIGHTS_TERMINAL)
SIXES_SEVENS_EIGHTS = Lingo::OrderedChoice.new(SIXES_TERMINAL, SEVENS_EIGHTS)

describe "Lingo::OrderedChoice" do
  describe "#matches?" do
    it "tries to match the first one, then falls back to the second" do
      SIXES_SEVENS_EIGHTS.matches?("66888").should eq(true)
      SIXES_SEVENS_EIGHTS.matches?("77888").should eq(true)
      SIXES_SEVENS_EIGHTS.matches?("888").should eq(true)
    end
  end

  describe "#parse" do
    it "applies the first successful parse" do
      six_result = SIXES_SEVENS_EIGHTS.parse("66888") as Lingo::Terminal::ParseResult
      six_result.match.should eq("66")
      six_result.string.should eq("888")

      eight_result = SIXES_SEVENS_EIGHTS.parse("88668") as Lingo::Terminal::ParseResult
      eight_result.match.should eq("88")
      eight_result.string.should eq("668")
    end
  end
end
