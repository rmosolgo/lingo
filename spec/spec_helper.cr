require "spec"
require "../src/lingo"
require "../examples/slow_json"

def math_parser
  Math.parser
end

module Math
  def self.eval(string_of_math)
    parse_result = @@parser.parse(string_of_math)
    math_visitor = Math::Visitor.new
    math_visitor.visit(parse_result)
    math_visitor.values.pop
  end

  def self.parser
    @@parser
  end

  def self.visitor
    Math::Visitor.new
  end

  alias Operand = Int32
  alias BinaryOperation = (Int32, Int32) -> Int32
  ADDITION = BinaryOperation.new { |left, right| left + right }
  MULTIPLICATION = BinaryOperation.new { |left, right| left * right }

  class Parser < Lingo::Parser
    root(:expression)
    rule(:expression) {
      integer.as(:operand) >>
        ws.repeat(0) >>
        (operator >> ws.repeat(0) >>  integer.as(:operand) >> ws.repeat(0)).repeat(0)
    }
    rule(:operator) { (plus.as(:plus) | times.as(:times))   }

    rule(:sign) { plus.as(:positive) | minus.as(:negative) }

    rule(:plus) { str("+") }
    rule(:minus) { str("-") }
    rule(:times) { str("*") }

    rule(:integer) { sign.maybe >> digit.repeat }
    rule(:digit) { str("0") | str("1") | str("3") | str("5") }
    rule(:ws) { match(/[\n\r\t\s]/) }
  end

  class Visitor < Lingo::Visitor
    alias ValueStack = Array(Operand)
    alias OperationStack =  Array(BinaryOperation)
    getter :values, :operations

    def initialize
      @values = ValueStack.new
      @operations = OperationStack.new
    end

    enter(:operand) {
      visitor.values << node.full_value.to_i
    }
    enter(:plus)  {
      visitor.operations << ADDITION
    }
    enter(:times)  {
      visitor.operations << MULTIPLICATION
    }

    exit(:expression) {
      op = visitor.operations.pop
      right = visitor.values.pop
      left = visitor.values.pop
      return_value = op.call(left, right)
      visitor.values << return_value
    }
  end

  @@parser = Parser.new
end
