class Lingo::OrderedChoice < Lingo::Constructable
  def initialize(@first, @second)
  end

  def parse?(raw_input)
    result = @first.parse?(raw_input) || @second.parse?(raw_input)
    if result.is_a?(Lingo::Node)
      result.name = @name
    end
    result
  end
end
