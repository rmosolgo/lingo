require "./lingo/*"

module Lingo
  alias Match = Token | Node

  class ParseFailedException < Exception
    property :last_result
    def initialize(@last_result)
      super("Parse failed!")
    end
  end
end
