class Lingo::Terminal
  include Lingo::Constructable
  getter :search
  property :name

  def initialize(@search : String)
  end

  def matches?(raw_input)
    raw_input.starts_with?(search)
  end

  def parse(raw_input)
    if raw_input.starts_with?(search)
      new_string = raw_input.sub(search, "")
      match = search
      ParseResult.new(match: match, string: new_string, name: name)
    else
      nil
    end
  end

  class ParseResult
    getter :match, :string, :name
    def initialize(@match="", @string="", @name=:sym)
    end
  end
end
