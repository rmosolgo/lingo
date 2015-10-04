class Lingo::Sequence < Lingo::Rule
  alias Parts = Array(Lingo::Rule)
  getter :parts

  def initialize(incoming_parts=Parts.new, @name=:anon)
    new_parts = Parts.new
    incoming_parts.each do |input|
      if input.is_a?(Lingo::Sequence)
        new_parts += input.parts
      else
        new_parts << input
      end
    end
    @parts = new_parts
  end

  def parse?(context : Lingo::Context)
    new_context = context.fork
    sequence_parent = node_constructor.new(children: [] of Lingo::Node)
    sequence_parent.name = @name
    new_context.push_node(sequence_parent)

    results = parts.map do |matcher|
      success = matcher.parse?(new_context)
      if !success
        break
      end
    end

    # Break causes it to be nil
    if results.is_a?(Array) && parts.size == results.size
      context.join(new_context)
      true
    else
      false
    end
  end

  def as(name)
    self.class.new(parts, name: name)
  end
end
