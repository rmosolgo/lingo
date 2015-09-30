require "./node"

abstract class Lingo::Constructable
  property :node_constructor


  abstract def parse?(raw_input: Lingo::Match)

  @node_constructor = Lingo::Node
  def parse(raw_input : String)
    result = Lingo::Token.new(remainder: raw_input)
    parse(result)
  end

  def parse(previous_result : Lingo::Match)
    raw_input = previous_result.remainder
    res = parse?(raw_input)
    if res.is_a?(Lingo::Match)
      n = node_constructor
      if n.nil?
        res
      else
        instance = n.new(res)
        instance
      end
    else
      raise ParseFailedException.new(previous_result)
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
end
