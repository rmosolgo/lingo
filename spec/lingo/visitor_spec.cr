require "../spec_helper"

describe "Lingo::Visitor" do
  describe "#visit" do
    it "transforms parse result, bottom-up" do
      return_value = Math.eval("-10+1")
      return_value.should eq(-9)

      parse_result = Math.parser.parse("5*3")
      result = Math.visitor.visit_node(parse_result)
      return_value = Math::VALUE_STACK.pop
      puts Math::VALUE_STACK
      return_value.should eq(15)
    end
  end
end
