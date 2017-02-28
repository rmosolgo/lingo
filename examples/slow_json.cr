require "../src/lingo"

module SlowJSON
  def self.parse(input_string)
    parse_result = JSONParser.new.parse(input_string)
    visitor = JSONVisitor.new
    visitor.visit(parse_result)
    visitor.values.pop
  end

  class JSONParser < Lingo::Parser
    root(:main_object)
    rule(:main_object) { space? >> object >> space? }

    rule(:object) {
      (str("{") >> space? >>
        (pair >> (comma >> pair).repeat(0)).maybe >>
        space? >> str("}")).named(:object)
    }

    rule(:comma) { space? >> str(",") >> space? }

    rule(:pair) { key.named(:key) >> kv_delimiter >> value.named(:value) }
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
          value.named(:value) >>
            (comma >> value.named(:value)).repeat(0)
        ).maybe >>
        space? >> str("]")).named(:array)
    }

    rule(:string) {
      str('"') >> (
        str("\\") >> any | str('"').absent >> any
      ).repeat.named(:string) >> str('"')
    }

    rule(:integer) { digits.named(:integer) }
    rule(:float) { (digits >> str(".") >> digits).named(:float) }

    rule(:value_true) { str("true").named(:true) }
    rule(:value_false) { str("false").named(:false) }
    rule(:value_null) { str("null").named(:null) }

    rule(:digits) { match(/[0-9]+/) }
    rule(:space?) { match(/\s+/).maybe }
  end

  alias JSONKey = String
  alias JSONValue = Hash(JSONKey, JSONValue) | Array(JSONValue) | Nil | Int32 | Float64 | String | Bool
  alias JSONArray = Array(JSONValue)
  alias JSONResult = Hash(JSONKey, JSONValue)

  class JSONVisitor < Lingo::Visitor
    getter :objects, :keys, :values

    def initialize
      @objects = [] of JSONResult | JSONArray
      @keys = [] of JSONKey
      @values = [] of JSONValue
    end

    exit(:key) {
      string = visitor.values.pop
      if string.is_a?(JSONKey)
        visitor.keys.push(string)
      else
        raise("Invalid JSON Key: #{string}")
      end
    }

    exit(:value) {
      value = visitor.values.pop
      current_object = visitor.objects.last
      if current_object.is_a?(JSONResult)
        key = visitor.keys.pop
        current_object[key] = value
      elsif current_object.is_a?(JSONArray)
        current_object << value
      else
        raise("Can't add without current object (#{value})")
      end
    }

    exit(:object) {
      visitor.objects.pop
    }

    exit(:array) {
      visitor.objects.pop
    }

    enter(:object) {
      new_obj = JSONResult.new
      visitor.objects << new_obj
      visitor.values << new_obj
    }

    enter(:array) {
      new_array = JSONArray.new
      visitor.objects << new_array
      visitor.values << new_array
    }

    enter(:string) { visitor.values << node.full_value }
    enter(:integer) { visitor.values << node.full_value.to_i }
    enter(:float) { visitor.values << node.full_value.to_f }
    enter(:true) { visitor.values << true }
    enter(:false) { visitor.values << false }
    enter(:null) { visitor.values << nil }
  end
end
