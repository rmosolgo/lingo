class Lingo::Sequence < Lingo::Constructable
  getter :parts

  def initialize(first, second)
    new_parts = [] of Lingo::Constructable
    [first, second].each do |input|
      if input.is_a?(Lingo::Sequence)
        new_parts += input.parts
      else
        new_parts << input
      end
    end
    @parts = new_parts
  end

  def parse?(raw_input)
    results = [] of Lingo::Node
    input_string = raw_input

    parts.each do |matcher|
      next_match = matcher.parse?(input_string)
      if next_match.is_a?(Lingo::Node)
        results << next_match
        input_string = next_match.remainder
      else
        break
      end
    end

    if parts.size == results.size
      node = node_constructor.new(
        remainder: input_string,
        children: results
      )
      node.name = @name
      node
    else
      nil
    end
  end
end
