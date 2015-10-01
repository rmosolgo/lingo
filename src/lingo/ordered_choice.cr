class Lingo::OrderedChoice < Lingo::Constructable
  def initialize(@first, @second)
  end

  def parse?(context : Lingo::Context)
    result = @first.parse?(context) || @second.parse?(context)
    if result.is_a?(Lingo::Node)
      new_result = result.chain(node_constructor)
      new_result.name = @name
      new_result
    else
      nil
    end
  end
end
