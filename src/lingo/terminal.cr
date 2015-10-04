class Lingo::Terminal < Lingo::Rule
  getter :search

  def initialize(@search : String, @name=nil)
  end

  def parse?(context : Lingo::Context)
    raw_input = context.remainder

    if raw_input.starts_with?(search)
      context.remainder = raw_input[search.size..-1]
      node = Lingo::Node.new(value: search)
      context.push_node(node)
      true
    else
      false
    end
  end
end
