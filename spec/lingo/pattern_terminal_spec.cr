require "../spec_helper"

letter_rule = Lingo::PatternTerminal.new(/[a-zA-Z]+/)
number_rule = Lingo::PatternTerminal.new(/[0-9]+/)

describe "Lingo::PatternTerminal" do
  it "finds Regex matches" do
    letters = letter_rule.parse("aBCdE")
    letters.full_value.should eq("aBCdE")
  end

  it "combines with others" do
    numbers_then_letters = number_rule >> letter_rule
    numbers_then_letters.matches?("1a").should eq(true)
    numbers_then_letters.matches?("771abc").should eq(true)
    numbers_then_letters.matches?("xw").should eq(false)
    numbers_then_letters.matches?("11").should eq(false)
    numbers_then_letters.matches?("df11").should eq(false)
  end
end
