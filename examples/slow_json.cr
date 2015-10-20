require "../src/lingo"

module SlowJSON
  def self.parse(input_string)
    parse_result = @@parser.parse(input_string)
    @@visitor.visit_node(parse_result)
    VALUE_STACK.pop
  end

  class Parser < Lingo::Parser
    root(:main_object)
    rule(:main_object) { space? >> object >> space? }

    rule(:object) {
      (str("{") >> space? >>
      (pair >> (comma >> pair).repeat(0)).maybe >>
      space? >> str("}")).as(:object)
    }

    rule(:comma) { space? >> str(",") >> space?}

    rule(:pair) { key.as(:key) >> kv_delimiter >> value.as(:value) }
    rule(:kv_delimiter) { space? >> str(":") >> space? }
    rule(:key) { string }
    rule(:value) {
      string | float | integer |
      object | array |
      value_true | value_false | value_null
    }

    rule(:array) {
      (str("[") >> space? >>
      (
        value.as(:value) >>
        (comma >> value.as(:value)).repeat(0)
      ).maybe >>
      space? >> str("]")).as(:array)
    }

    rule(:string) {
      str('"') >> (
        str("\\") >> any | str('"').absent >> any
      ).repeat.as(:string) >> str('"')
    }

    rule(:integer) { digits.as(:integer) }
    rule(:float) { (digits >> str(".") >> digits).as(:float) }

    rule(:value_true) { str("true").as(:true) }
    rule(:value_false) { str("false").as(:false) }
    rule(:value_null) { str("null").as(:null) }

    rule(:digits) { match(/[0-9]+/) }
    rule(:space?) { match(/\s*/) }
  end

  alias JSONKey = String
  alias JSONValue = Hash(JSONKey, JSONValue) | Array(JSONValue) | Nil | Int32 | Float64 | String | Bool
  alias JSONArray = Array(JSONValue)
  alias JSONResult = Hash(JSONKey, JSONValue)
  OBJECT_STACK = [] of JSONResult | JSONArray
  KEY_STACK = [] of JSONKey
  VALUE_STACK = [] of JSONValue

  class Visitor < Lingo::Visitor
    exit(:key) {
      string = VALUE_STACK.pop
      if string.is_a?(JSONKey)
        KEY_STACK.push(string)
      else
        raise("Invalid JSON Key: #{string}")
      end
    }

    exit(:value) {
      value = VALUE_STACK.pop
      current_object = OBJECT_STACK.last
      if current_object.is_a?(JSONResult)
        key = KEY_STACK.pop
        current_object[key] = value
      elsif current_object.is_a?(JSONArray)
        current_object << value
      else
        raise("Can't add without current object (#{value})")
      end
    }

    exit(:object) {
      OBJECT_STACK.pop
    }

    exit(:array) {
      OBJECT_STACK.pop
    }

    enter(:object) {
      new_obj = JSONResult.new
      OBJECT_STACK << new_obj
      VALUE_STACK << new_obj
    }

    enter(:array) {
      new_array = JSONArray.new
      OBJECT_STACK << new_array
      VALUE_STACK << new_array
    }

    enter(:string) { VALUE_STACK << node.full_value }
    enter(:integer) { VALUE_STACK << node.full_value.to_i }
    enter(:float) { VALUE_STACK << node.full_value.to_f }
    enter(:true) { VALUE_STACK << true }
    enter(:false) { VALUE_STACK << false }
    enter(:null) { VALUE_STACK << nil }
  end

  @@parser = Parser.new
  @@visitor = Visitor.new
end
