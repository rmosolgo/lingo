require "./node"

abstract class Lingo::Rule
  abstract def parse?(context : Lingo::Context)

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
    remainder = context.remainder
    result_node = context.root
    if success && remainder == "" && result_node.is_a?(Lingo::Node)
      result_node
    else
      raise ParseFailedException.new(context)
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
    repeat(0, 1)
  end

  def repeat(from = 1, to = Float32::INFINITY)
    Lingo::Repeat.new(self, from: from, to: to)
  end

  def named(name)
    Lingo::NamedRule.new(name, self)
  end

  def absent
    Lingo::NotRule.new(self)
  end
end
