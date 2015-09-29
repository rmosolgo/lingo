class Lingo::Sequence
  include Lingo::Constructable
  property :name

  def initialize(@first, @second)
  end

  def matches?(raw_input)
    if @first.matches?(raw_input)
      remainder = @first.parse(raw_input)
      if remainder.is_a?(Lingo::Terminal::ParseResult)
        @second.matches?(remainder.string)
      else
        false
      end
    else
      false
    end
  end

  def parse(raw_input)
    if matches?(raw_input)
      first_result = @first.parse(raw_input) as Lingo::Terminal::ParseResult
      second_result = @second.parse(first_result.string) as Lingo::Terminal::ParseResult
      result = Lingo::Terminal::ParseResult.new(
        match: first_result.match + second_result.match,
        string: second_result.string,
        name: name
      )
    end
  end
end
