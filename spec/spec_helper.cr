require "spec"
require "../src/lingo"
require "../examples/slow_json"

def math_parser
  Math.parser
end

module Math
  def self.eval(string_of_math)
    parse_result = @@parser.parse(string_of_math)
    result = @@visitor.visit_node(parse_result)
    return_value = Math::VALUE_STACK.pop
  end

  def self.parser
    @@parser
  end

  def self.visitor
    @@visitor
  end

  alias Operand = Int32
  alias BinaryOperation = (Int32, Int32) -> Int32
  ADDITION = BinaryOperation.new { |left, right| left + right }
  MULTIPLICATION = BinaryOperation.new { |left, right| left * right }
  VALUE_STACK = [] of Operand
  OPERATION_STACK = [] of BinaryOperation

  class Parser < Lingo::Parser
    root(:expression)
    rule(:expression) {
      integer.as(:operand) >> (operator >> integer.as(:operand)).repeat(0)
    }
    rule(:operator) { plus.as(:plus) | times.as(:times) }

    rule(:sign) { plus.as(:positive) | minus.as(:negative) }

    rule(:plus) { str("+") }
    rule(:minus) { str("-") }
    rule(:times) { str("*") }

    rule(:integer) { sign.maybe >> digit.repeat }
    rule(:digit) { str("0") | str("1") | str("3") | str("5") }
  end

  class Visitor < Lingo::Visitor
    enter(:operand) {
      VALUE_STACK << node.full_value.to_i
    }
    enter(:plus)  {
      OPERATION_STACK << ADDITION
    }
    enter(:times)  {
      OPERATION_STACK << MULTIPLICATION
    }

    exit(:expression) {
      op = OPERATION_STACK.pop
      right = VALUE_STACK.pop
      left = VALUE_STACK.pop
      return_value = op.call(left, right)
      VALUE_STACK << return_value
    }
  end

  @@parser = Parser.new
  @@visitor = Visitor.new
end
