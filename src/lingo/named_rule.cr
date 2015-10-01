class Lingo::NamedRule < Lingo::Constructable
  getter :inner

  def initialize(@inner)
  end

  def parse?(raw_input)
    node = @inner.parse?(raw_input)
    if node.is_a?(Lingo::Node)
      new_node = node.chain(node_constructor)
      new_node.name = @name
      new_node
    else
      nil
    end
  end
end
