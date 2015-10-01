require "./lingo/*"

module Lingo
  class ParseFailedException < Exception
    property :last_result
    def initialize(@last_result)
      super("Parse failed!")
    end
  end
end
