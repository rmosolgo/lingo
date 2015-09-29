class Lingo::OrderedChoice
  include Lingo::Constructable

  property :name

  def initialize(@first : Rule, @second : Rule)
  end

  def matches?(raw_input)
    @first.matches?(raw_input) || @second.matches?(raw_input)
  end

  def parse?(raw_input)
    result = @first.parse?(raw_input) || @second.parse?(raw_input)
    if result.is_a?(Lingo::Match)
      result
    else
      nil
    end
  end
end
