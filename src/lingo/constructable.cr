module Lingo::Constructable
  def parse(raw_input : String)
    result = Lingo::Token.new(remainder: raw_input)
    parse(result)
  end

  def parse(previous_result : Lingo::Match) : Lingo::Match
    raw_input = previous_result.remainder
    res = parse?(raw_input)
    if res.is_a?(Lingo::Match)
      res
    else
      raise ParseFailedException.new(previous_result)
    end
  end

  def |(other : Lingo::Rule)
    Lingo::OrderedChoice.new(self, other)
  end

  def >>(other : Lingo::Rule)
    Lingo::Sequence.new(self, other)
  end
end
