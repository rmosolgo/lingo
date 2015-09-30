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
end
