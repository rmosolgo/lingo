require "spec"
require "../src/lingo"

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
  alias UnaryOperation = (Int32) -> Int32
  alias BinaryOperation = (Int32, Int32) -> Int32
  alias Operation = UnaryOperation | BinaryOperation
  POSITIVE = UnaryOperation.new { |right| right }
  NEGATIVE = UnaryOperation.new { |right| 0 - right }

  ADDITION = BinaryOperation.new { |left, right| left + right }
  MULTIPLICATION = BinaryOperation.new { |left, right| left * right }

  class Parser < Lingo::Parser
    root(:expression)
    rule(:expression) { binary_operation.as(:binary) }
    rule(:binary_operation) {
      integer.as(:operand) >>
      binary_operator >>
      integer.as(:operand)
    }
    rule(:binary_operator) { plus.as(:plus) | times.as(:times) }

    rule(:sign) { plus.as(:positive) | minus.as(:negative) }

    rule(:plus) { str("+") }
    rule(:minus) { str("-") }
    rule(:times) { str("*") }

    rule(:integer) { sign.maybe >> digit.repeat }
    rule(:digit) { str("0") | str("1") | str("3") | str("5") }
  end


  VALUE_STACK = [] of Operand
  OPERATION_STACK = [] of Operation

  class Visitor < Lingo::Visitor
    enter(:operand) {
      puts "operand: #{node.full_value}"
      VALUE_STACK << node.full_value.to_i
    }
    enter(:plus)  {
      puts "op: +"
      OPERATION_STACK << ADDITION
    }
    enter(:times)  {
      puts "op: *"
      OPERATION_STACK << MULTIPLICATION
    }

    exit(:binary) {
      op = OPERATION_STACK.pop
      puts "Pop: #{op}"
      if op.is_a?(BinaryOperation)
        right = VALUE_STACK.pop
        left = VALUE_STACK.pop
        return_value = op.call(left, right)
        VALUE_STACK << return_value
      else
        raise("Not a binary operation")
      end
    }

    exit(:unary) {
      op = OPERATION_STACK.pop
      puts "Pop: #{op}"
      if op.is_a?(UnaryOperation)
        right = VALUE_STACK.pop
        return_value = op.call(right)
        VALUE_STACK << return_value
      else
        raise("Not a unary operation")
      end
    }
  end

  @@parser = Parser.new
  @@visitor = Visitor.new
end
