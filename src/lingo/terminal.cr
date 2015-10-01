class Lingo::Terminal < Lingo::Constructable
  getter :search

  def initialize(@search : String)
  end

  def parse?(raw_input)
    if raw_input.starts_with?(search)
      new_string = raw_input[search.size..-1]
      match = search
      node = node_constructor.new(value: match, remainder: new_string)
      node.name = @name
      node
    else
      nil
    end
  end
end
