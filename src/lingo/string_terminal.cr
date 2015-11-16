class Lingo::StringTerminal < Lingo::Rule
  getter :search

  def initialize(search : String | Char)
    @search = search.to_s
  end

  def parse?(context : Lingo::Context)
    raw_input = context.remainder

    if raw_input.starts_with?(search)
      node = Lingo::Node.new(value: search, line: context.line, column: context.column)
      context.consume(search)
      context.push_node(node)
      true
    else
      false
    end
  end
end
