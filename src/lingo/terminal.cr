class Lingo::Terminal < Lingo::Constructable
  getter :search

  def initialize(@search : String)
  end

  def parse?(context : Lingo::Context)
    raw_input = context.remainder
    if raw_input.starts_with?(search)
      context.remainder = raw_input[search.size..-1]
      node = node_constructor.new(value: search)
      node.name = @name
      node
    else
      nil
    end
  end
end
