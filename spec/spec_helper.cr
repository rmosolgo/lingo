require "spec"
require "../src/lingo"

def math_parser
  Math::Parser.new
end

module Math
  alias Operand = Int32
  alias Operation = (Int32, Int32) -> Int32
  ADDITION = Operation.new { |left, right| left + right }
  MULTIPLICATION = Operation.new { |left, right| left * right }

  class Parser < Lingo::Parser
    root(:expression)
    rule(:expression) { integer.as(:operand) >> (operation >> integer.as(:operand)).repeat }
    rule(:operation) { plus | times }
    rule(:plus) { str("+").as(:plus) }
    rule(:times) { str("*").as(:times) }
    rule(:integer) { digit >> digit.maybe }
    rule(:digit) { str("0") | str("1") | str("3") | str("5") }
  end


  VALUE_STACK = [] of Operand
  OPERATION_STACK = [] of Operation

  class Visitor < Lingo::Visitor
    enter(:operand) {
      VALUE_STACK << node.value.to_i
    }
    enter(:plus)  {
      OPERATION_STACK << ADDITION
    }
    enter(:times)  {
      OPERATION_STACK << MULTIPLICATION
    }
    exit(:expression) {
      right = VALUE_STACK.pop
      left = VALUE_STACK.pop
      op = OPERATION_STACK.pop
      return_value = op.call(left, right)
      VALUE_STACK << return_value
    }
  end
end
