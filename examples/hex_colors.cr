require "../src/lingo"

module HexColors
  def self.parse(color_string)
    tree = Parser.new.parse(color_string)
    visitor = Visitor.new
    visitor.visit_node(tree)
    COLOR_STACK.pop
  end

  class Color
    property :red, :green, :blue
    def to_s
      "<Color red:#{red} green:#{green} blue:#{blue}>"
    end
  end


  class Parser < Lingo::Parser
    root(:color)

    rule(:color) { hash_mark >> octet.as(:red) >> octet.as(:green) >> octet.as(:blue) }
    rule(:hash_mark) { str("#") }
    rule(:octet) { match(/[0-9A-f]{2}/i)}
  end

  COLOR_STACK = [] of Color
  class Visitor < Lingo::Visitor
    getter :color

    enter(:color) {
      COLOR_STACK << Color.new
    }

    enter(:red) {
      COLOR_STACK[0].red = node.full_value.upcase
    }
    enter(:blue) {
      COLOR_STACK[0].blue = node.full_value.upcase
    }
    enter(:green) {
      COLOR_STACK[0].green = node.full_value.upcase
    }
  end
end

puts HexColors.parse("#ff0000").to_s
puts HexColors.parse("#ab1276").to_s
