module Lingo::Constructable
  def |(other : Lingo::Rule)
    Lingo::OrderedChoice.new(self, other)
  end

  def >>(other : Lingo::Rule)
    Lingo::Sequence.new(self, other)
  end
end
