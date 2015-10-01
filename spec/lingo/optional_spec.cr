require "../spec_helper"

describe "Lingo::Optional" do
  pending "it maybe matches things" do
    optional = math_parser.plus.maybe
    optional.parse?("-").should eq(nil)
    optional.parse?("+").should be_a?(Lingo::Node)
  end
end
