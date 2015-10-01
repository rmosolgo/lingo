require "../spec_helper"

describe "Lingo::Visitor" do
  describe "#visit" do
    it "transforms parse result, bottom-up" do
      visitor = Math::Visitor.new
      parser = math_parser
      parse_result = parser.parse("1+1")
      result = visitor.visit_node(parse_result)
      result.should eq(2)
    end
  end
end
