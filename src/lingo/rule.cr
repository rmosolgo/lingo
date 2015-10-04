require "./node"

abstract class Lingo::Rule
  class InputNode < Lingo::Node
  end
  property :node_constructor

  abstract def parse?(context : Lingo::Context)

  @node_constructor = Lingo::Node
  @name = :anon

  def parse(raw_input : String)
    context = Lingo::Context.new(raw_input)
    parse(context)
  end

  def parse?(raw_input : String)
    context = Lingo::Context.new(raw_input)
    parse?(context)
  end

  def parse(context : Lingo::Context)
    res = parse?(context)
    if res.is_a?(Lingo::Node)
      res
    else
      raise ParseFailedException.new(context.remainder)
    end
  end

  def matches?(raw_input)
    !!parse?(raw_input)
  end

  def |(other : Lingo::Rule)
    Lingo::OrderedChoice.new(self, other)
  end

  def >>(other : Lingo::Rule)
    Lingo::Sequence.new(self, other)
  end

  def maybe
    Lingo::Optional.new(self)
  end

  def as(name)
    @name = name
    self
  end
end
