class Lingo::Context
  property :remainder, :current_node, :root

  def initialize(@remainder="", @root=nil)
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
    self.class.new(remainder: remainder, root: root)
  end

  def join(other_context)
    @remainder = other_context.remainder
    other_root = other_context.root
    if other_root.is_a?(Lingo::Node)
      push_node(other_root)
    else
      raise("Can't rejoin a context without a root")
    end
  end
end
