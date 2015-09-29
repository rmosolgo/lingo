require "spec"
require "../src/lingo"

def math_parser
  Math::Parser.new
end

module Math
  class Addition
    def apply(left, right) : Int32
      left + right
    end
  end

  class Parser < Lingo::Parser
    root(:expression)
    rule(:expression) { digit >> operation >> digit }
    rule(:operation) { plus }
    rule(:plus) { str("+") }
    rule(:digit) { str("0") | str("1") }
  end

  class  Visitor < Lingo::Visitor
    visit({digit: String}) { |values|
      digit = values[:digit] as String
      digit.to_i
    }
    # visit(:plus, Addition) { Addition.new }
    # visit(:expression, Int32) do |exp|
    #   op = exp.operation as Addition
    #   left = exp.left as Int32
    #   right = exp.right as Int32
    #   op.apply(left, right)
    # end
  end


end
