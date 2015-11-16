class Lingo::ParseFailedException < Exception
  property :context

  def initialize(@context)
    super("Parse failed at #{position} (\"#{next_text(5)}\")")
  end

  private def next_text(length)
    next_chars = @context.remainder[0..length]

    if @context.remainder.size > length
      next_chars += "..."
    end
    next_chars
  end

  private def position
    "#{@context.line}:#{@context.column}"
  end
end
