require "spec"
require "../src/lingo"

def math_parser
  MathParser.new
end

class MathParser < Lingo::Parser
  root(:expression)
  rule(:expression) { digit >> plus >> digit }
  rule(:plus) { str("+") }
  rule(:digit) { str("0") | str("1") }
end
