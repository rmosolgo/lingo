require "../src/lingo"

module HexColors
  def self.parse(color_string)
    tree = Parser.parse(color_string)
    visitor = Visitor.new
    visitor.visit(tree)
    visitor.color
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


  class Visitor < Lingo::Visitor
    getter :color
    def initialize
      @color = Color.new
    end
    enter(:red) {
      visitor.color.red = node.full_value.upcase
    }
    enter(:blue) {
      visitor.color.blue = node.full_value.upcase
    }
    enter(:green) {
      visitor.color.green = node.full_value.upcase
    }
  end
end

puts HexColors.parse("#ff0000").to_s
puts HexColors.parse("#ab1276").to_s
