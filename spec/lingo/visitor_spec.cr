require "../spec_helper"

describe "Lingo::Visitor" do
  describe "#visit" do
    it "transforms parse result, bottom-up" do
      visitor = Math::Visitor.new
      parser = math_parser
      parse_result = parser.parse("1+1")
      result = visitor.visit_node(parse_result)
      return_value = Math::VALUE_STACK.pop
      return_value.should eq(2)

      parse_result = parser.parse("5*3")
      result = visitor.visit_node(parse_result)
      return_value = Math::VALUE_STACK.pop
      return_value.should eq(15)
    end
  end
end
