require "../spec_helper"

not_plus = Math.parser.plus.absent

describe "Lingo::NotRule" do
  it "is true if the rule is _not_ found" do
    not_plus.matches?("-").should eq(true)
    not_plus.matches?("+").should eq(false)
  end
end
