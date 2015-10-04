require "../spec_helper"

describe "Crystal::Repeat" do
  it "matches from -> to repetitions" do
    digits = math_parser.digit.repeat(3,6)
    digits.parse?("13").should eq(false)
    digits.parse?("103").should eq(true)
    digits.parse?("1031").should eq(true)
    digits.parse?("103555").should eq(true)
    digits.parse?("1035115").should eq(false)
  end

  it "defaults to: Infinity" do
    plusses = math_parser.plus.repeat(2)
    plusses.parse?("+").should eq(false)
    plusses.parse?("++").should eq(true)
    plusses.parse?("++++++++++++++").should eq(true)
  end

  it "works with 0 -> 1" do
    plusses = math_parser.plus.repeat(0, 1)
    plusses.parse?("").should eq(true)
    plusses.parse?("+").should eq(true)
    plusses.parse?("++").should eq(false)
  end
end
