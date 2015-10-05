require "../src/lingo"

module SlowJSON
  def self.parse(input_string)
    parse_result = @@parser.parse(input_string)
    @@visitor.visit_node(parse_result)
    OBJECT_STACK.pop
  end

  class Parser < Lingo::Parser
    root(:object)
    rule(:object) { str("{") >> space? >> pair.repeat(0) >> space? >> str("}") }

    rule(:pair) { key.as(:key) >> space? >> str(":") >> space? >> value.as(:value) }
    rule(:key) { string }
    rule(:value) { str("1")}
    rule(:string) { str('"') >> str("a") >> str('"') }
    rule(:space?) { str(" ").repeat(0) }
  end

  alias JSONKey = String
  alias JSONValue = Hash(JSONKey, JSONValue) | Array(JSONValue) | Nil | Int32 | Float64 | String | Bool
  alias JSONResult = Hash(JSONKey, JSONValue)
  OBJECT_STACK = [] of JSONResult
  KEY_STACK = [] of JSONKey

  class Visitor < Lingo::Visitor
    enter(:object) { OBJECT_STACK.push(JSONResult.new) }
    enter(:key) { KEY_STACK.push(node.full_value) }
    enter(:value) {
      key = KEY_STACK.pop
      value = node.full_value
      current_object = OBJECT_STACK.last
      if current_object.is_a?(JSONResult)
        current_object[key] = value
      else
        raise("Can't add without current object (#{key} => #{value})")
      end
    }
    exit(:object) {
      if OBJECT_STACK.size > 1
        OBJECT_STACK.pop
      end
    }
  end

  @@parser = Parser.new
  @@visitor = Visitor.new
end
