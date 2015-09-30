class Lingo::Sequence < Lingo::Constructable

  def initialize(@first, @second)
  end

  def parse?(raw_input)
    result = nil

    first_result = @first.parse?(raw_input)

    if first_result.is_a?(Lingo::Match)
      second_result = @second.parse?(first_result.remainder)
      if second_result.is_a?(Lingo::Match)
        result = Lingo::Token.new(
          value: first_result.value + second_result.value,
          remainder: second_result.remainder,
        )
      end
    end

    result
  end
end
