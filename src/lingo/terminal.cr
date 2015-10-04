class Lingo::Terminal < Lingo::Rule
  getter :search

  def initialize(@search : String, @name=:anon)
  end

  def parse?(context : Lingo::Context)
    raw_input = context.remainder
    if raw_input.starts_with?(search)
      context.remainder = raw_input[search.size..-1]
      node = node_constructor.new(value: search)
      node.name = @name
      context.push_node(node)
      true
    else
      false
    end
  end

  def as(name)
    self.class.new(@search, name: name)
  end
end
