require "./node"

abstract class Lingo::Rule
  class InputNode < Lingo::Node
  end
  property :node_constructor

  abstract def parse?(context : Lingo::Context)
  abstract def as(name)

  @node_constructor = Lingo::Node
  @name = :anon
  getter :name

  def parse(raw_input : String)
    context = Lingo::Context.new(remainder: raw_input)
    parse(context)
  end

  def parse?(raw_input : String)
    context = Lingo::Context.new(raw_input)
    parse?(context)
  end

  def parse(context : Lingo::Context)
    success = parse?(context)
    result_node = context.root
    if success && result_node.is_a?(Lingo::Node)
      result_node
    else
      raise ParseFailedException.new(context.remainder)
    end
  end

  def matches?(raw_input)
    !!parse?(raw_input)
  end

  def |(other : Lingo::Rule)
    Lingo::OrderedChoice.new([self, other])
  end

  def >>(other : Lingo::Rule)
    Lingo::Sequence.new([self, other])
  end

  def maybe
    Lingo::Optional.new(self)
  end
end
