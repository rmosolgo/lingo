# Lingo [![Build Status](https://travis-ci.org/rmosolgo/lingo.svg)](https://travis-ci.org/rmosolgo/lingo)

A parser generator for Crystal, inspired by [Parslet](https://github.com/kschiess/parslet).

Lingo provides text processing by:
- parsing the string into a tree of nodes
- providing a visitor to allow you to work from the tree

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  lingo:
    github: rmosolgo/lingo
```

## Usage

Let's write a parser for highway names. The result will be a method for turning strings into useful objects:

```ruby
def parse_road(input_str)
  ast = RoadParser.parse(input_str)
  visitor = RoadVisitor.new
  visitor.visit(ast)
  visitor.road
end

road = parse_road("I-5N")
# <Road @interstate=true, @number=5, @direction="N">
```

(See more examples in [`/examples`](https://github.com/rmosolgo/lingo/tree/master/examples).)

In the USA, we write highway names like this:

```
50    # Route 50
I-64  # Interstate 64
I-95N # Interstate 95, Northbound
29B   # Business Route 29
```

### Parser

The general structure is `{interstate?}{number}{direction}{business?}`. Let's express that with Lingo rules:

```ruby
class RoadParser < Lingo::Parser
  # Match a string:
  rule(:interstate) { str("I-") }
  rule(:business) { str("B") }

  # Match a regex:
  rule(:digit) { match(/\d/) }
  # Express repetition with `.repeat`
  rule(:number) { digit.repeat }

  rule(:north) { str("N") }
  rule(:south) { str("S") }
  rule(:east) { str("E") }
  rule(:west) { str("W") }
  # Compose rules by name
  # Express alternation with |
  rule(:direction) { north | south | east | west }

  # Express sequence with >>
  # Express optionality with `.maybe`
  # Name matched strings with `.as`
  rule(:road_name) {
    interstate.as(:interstate).maybe >>
      number.as(:number) >>
      direction.as(:direction).maybe >>
      business.as(:business).maybe
  }
  # You MUST name a starting rule:
  root(:road_name)
end
```

#### Applying the Parser

The resulting class has a `.parse` method which returns a tree of `Lingo::Node`s.

```ruby
RoadParser.parse("250B") # => <Lingo::Node ... >
```

It uses the rule named by `root`.

#### Making Rules

These methods help you create rules:

- `str("string")` matches string exactly
- `match(/[abc]/)` matches the regex exactly
- `a | b` matches `a` _or_ `b`
- `a >> b` matches `a` _followed by_ `b`
- `a.maybe` matches `a` or nothing
- `a.repeat` matches _one-or-more_ `a`s
- `a.repeat(0)` matches _zero-or-more_ `a`s
- `a.absent` matches _not-`a`_
- `a.as(:a)` names the result `:a` for handling by a visitor

### Visitor

After parsing, you get a tree of `Lingo::Node`s. To turn that into an application object, write a visitor.

The visitor may define `enter` and `exit` hooks for nodes named with `.as` in the Parser. It may set up some state during `#initialize`, then access itself from the `visitor` variable during hooks.


```ruby
class RoadVisitor < Lingo::Visitor
  # Set up an accumulator
  getter :road
  def initialize
    @road = Road.new
  end

  # When you find a named node, you can do something with it.
  # You can access the current visitor as `visitor`
  enter(:interstate) {
    # since we found this node, this is a business route
    visitor.road.interstate = true
  }

  # You can access the named Lingo::Node as `node`.
  # Get the matched string with `.full_value`
  enter(:number) {
    visitor.road.number = node.full_value.to_i
  }

  enter(:direction) {
    visitor.road.direction = node.full_value
  }

  enter(:business) {
    visitor.road.business = true
  }
end
```

#### Visitor Hooks

During the depth-first visitation of the resulting tree of `Lingo::Node`s, you can handle visits to nodes named with `.as`:

- `enter(:match)` is called when entering a node named `:match`
- `exit(:match)` is called when exiting a node named `:match`

Within the hooks, you can access two magic variables:

- `visitor` is the Visitor itself
- `node` is the matched `Lingo::Node` which exposes:
  - `#full_value`: the full matched string
  - `#line`, `#column`: position information for this match

## About this Project

### Goals

- Low barrier to entry: easy-to-learn API, short zero-to-working time
- Easy-to-read code, therefore easy-to-modify
- Useful errors (not accomplished)

### Non-goals

- Blazing-fast performance
- Theoretical correctness

### TODO

- [ ] Add some kind of debug output

### How slow is it?

Let's compare the built-in JSON parser to a Lingo JSON parser:

```
./lingo/benchmark $ crystal run --release slow_json.cr
Stdlib JSON  126.2k (± 1.09%)        fastest
Lingo::JSON 668.61  (± 1.36%) 188.76× slower
```

Ouch, that's __a lot slower__.

But, it's on par with Ruby and `parslet`, the inspiration for this project:

```
$ ruby parslet_json_benchmark.rb
Calculating -------------------------------------
       Parslet JSON      4.000  i/100ms
       Built-in JSON     3.657k i/100ms
-------------------------------------------------
       Parslet JSON      45.788  (± 4.4%) i/s -    232.000
       Built-in JSON     38.285k (± 5.3%) i/s -    193.821k

Comparison:
       Built-in JSON:    38285.2 i/s
       Parslet JSON :       45.8 i/s - 836.13x slower
```

Both Parslet and Lingo are slower than handwritten parsers. But, they're easier to write!

## Development

- Run the __tests__ with `crystal spec`
- Install Ruby & `guard`, then start a __watcher__ with `guard`
