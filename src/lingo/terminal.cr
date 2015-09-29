class Lingo::Terminal
  include Lingo::Constructable
  getter :search
  property :name

  def initialize(@search : String)
  end

  def matches?(raw_input)
    raw_input.starts_with?(search)
  end

  def parse?(raw_input)
    if raw_input.starts_with?(search)
      new_string = raw_input[search.size..-1]
      match = search
      Lingo::Token.new(value: match, remainder: new_string, name: name)
    else
      nil
    end
  end
end
