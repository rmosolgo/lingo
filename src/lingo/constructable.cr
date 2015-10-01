require "./node"

abstract class Lingo::Constructable
  class InputNode < Lingo::Node
  end
  property :node_constructor

  abstract def parse?(raw_input: Lingo::Node)

  @node_constructor = Lingo::Node
  @name = :anon
  def parse(raw_input : String)
    res = parse?(raw_input)
    if res.is_a?(Lingo::Node)
      res
    else
      raise ParseFailedException.new(raw_input)
    end
  end

  def matches?(raw_input)
    !!parse?(raw_input)
  end

  def |(other : Lingo::Constructable)
    Lingo::OrderedChoice.new(self, other)
  end

  def >>(other : Lingo::Constructable)
    Lingo::Sequence.new(self, other)
  end

  def as(name)
    @name = name
    self
  end
end
