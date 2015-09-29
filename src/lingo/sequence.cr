class Lingo::Sequence
  include Lingo::Constructable
  property :name

  def initialize(@first, @second)
  end

  def matches?(raw_input)
    remainder = @first.parse?(raw_input)
    if remainder.is_a?(Lingo::Match)
      @second.matches?(remainder.remainder)
    else
      false
    end
  end

  def parse?(raw_input)
    if matches?(raw_input)
      first_result = @first.parse(raw_input)
      second_result = @second.parse(first_result.remainder)
      result = Lingo::Token.new(
        value: first_result.value + second_result.value,
        remainder: second_result.remainder,
        name: name
      )
    end
  end
end
