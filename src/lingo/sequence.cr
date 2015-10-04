class Lingo::Sequence < Lingo::Rule
  getter :parts

  def initialize(first, second)
    new_parts = [] of Lingo::Rule
    [first, second].each do |input|
      if input.is_a?(Lingo::Sequence)
        new_parts += input.parts
      else
        new_parts << input
      end
    end
    @parts = new_parts
  end

  def parse?(context : Lingo::Context)
    results = [] of Lingo::Node

    parts.each do |matcher|
      next_match = matcher.parse?(context)
      if next_match.is_a?(Lingo::Node)
        results << next_match
      else
        break
      end
    end

    if parts.size == results.size
      node = node_constructor.new(
        children: results
      )
      node.name = @name
      node
    else
      nil
    end
  end
end
