require "./lingo/*"

module Lingo
  alias Rule = Terminal | OrderedChoice | Sequence
  alias Match = Token
  class ParseFailedException < Exception
    property :last_result
    def initialize(@last_result)
      super("Parse failed!")
    end
  end
end
