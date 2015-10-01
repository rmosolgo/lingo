class Lingo::NamedRule < Lingo::Constructable
  getter :inner

  def initialize(@inner)
  end

  def parse?(context : Lingo::Context)
    node = @inner.parse?(context)
    if node.is_a?(Lingo::Node)
      new_node = node.chain(node_constructor)
      new_node.name = @name
      new_node
    else
      nil
    end
  end
end
