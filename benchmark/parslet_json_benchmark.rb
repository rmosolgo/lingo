
require 'parslet'
require 'benchmark/ips'
require 'json'

# From a parslet example on Github
module MyJson
  class Parser < Parslet::Parser
    rule(:spaces) { match('\s').repeat(1) }
    rule(:spaces?) { spaces.maybe }

    rule(:comma) { spaces? >> str(',') >> spaces? }
    rule(:digit) { match('[0-9]') }

    rule(:number) {
      (
        str('-').maybe >> (
          str('0') | (match('[1-9]') >> digit.repeat)
        ) >> (
          str('.') >> digit.repeat(1)
        ).maybe >> (
          match('[eE]') >> (str('+') | str('-')).maybe >> digit.repeat(1)
        ).maybe
      ).as(:number)
    }

    rule(:string) {
      str('"') >> (
        str('\\') >> any | str('"').absent? >> any
      ).repeat.as(:string) >> str('"')
    }

    rule(:array) {
      str('[') >> spaces? >>
      (value >> (comma >> value).repeat).maybe.as(:array) >>
      spaces? >> str(']')
    }

    rule(:object) {
      str('{') >> spaces? >>
      (entry >> (comma >> entry).repeat).maybe.as(:object) >>
      spaces? >> str('}')
    }

    rule(:value) {
      string | number |
      object | array |
      str('true').as(:true) | str('false').as(:false) |
      str('null').as(:null)
    }

    rule(:entry) {
      (
         string.as(:key) >> spaces? >>
         str(':') >> spaces? >>
         value.as(:val)
      ).as(:entry)
    }

    rule(:attribute) { (entry | value).as(:attribute) }

    rule(:top) { spaces? >> value >> spaces? }

    root(:top)
  end

  class Transformer < Parslet::Transform

    class Entry < Struct.new(:name, :val); end

    rule(:array => subtree(:ar)) {
      ar.is_a?(Array) ? ar : [ ar ]
    }
    rule(:object => subtree(:ob)) {
      (ob.is_a?(Array) ? ob : [ ob ]).inject({}) { |h, e| h[e.name] = e.val; h }
    }

    rule(:entry => { :key => simple(:ke), :val => subtree(:va) }) {
      Entry.new(ke, va)
    }

    rule(:string => simple(:st)) {
      st.to_s
    }
    rule(:number => simple(:nb)) {
      nb.match(/[eE\.]/) ? Float(nb) : Integer(nb)
    }

    rule(:null => simple(:nu)) { nil }
    rule(:true => simple(:tr)) { true }
    rule(:false => simple(:fa)) { false }
  end

  TRANSFORMER = Transformer.new
  PARSER = Parser.new
  def self.parse(s)
    tree = PARSER.parse(s)
    out = TRANSFORMER.apply(tree)
    out
  end
end


JSON_TEXT = File.read("./mtg_json.json")

Benchmark.ips do |x|
  x.report("Parslet JSON ") { MyJson.parse(JSON_TEXT) }
  x.report("Built-in JSON") { JSON.parse(JSON_TEXT) }
  x.compare!
end
