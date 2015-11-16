class Lingo::Context
  property :remainder, :current_node, :root, :column, :line

  def initialize(@remainder="", @root=nil, @column=1, @line=1)
  end

  def push_node(parsed_node)
    current_root = @root

    if current_root.nil?
      @root = parsed_node
    elsif current_root.is_a?(Lingo::Node)
      current_root.children << parsed_node
    end

    nil
  end

  def fork(root=nil)
    self.class.new(remainder: remainder, root: root, column: column, line: line)
  end

  def join(other_context)
    @remainder = other_context.remainder
    @column = other_context.column
    @line = other_context.line
    other_root = other_context.root
    if other_root.is_a?(Lingo::Node)
      push_node(other_root)
    else
      raise("Can't rejoin a context without a root")
    end
  end

  def consume(matched_string)
    new_lines = matched_string.count("\n")
    last_line = matched_string.split("\n").last
    @line += new_lines

    if new_lines > 0
      @column = last_line.size
    else
      @column += last_line.size
    end

    char_count = matched_string.size
    @remainder = @remainder[char_count..-1]
  end
end
