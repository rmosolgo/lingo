class Lingo::Context
  property :remainder, :current_node, :root

  def initialize(@remainder)
  end

  def add_child(parsed_node)
    if @current_node.is_a?(Lingo::Node)
      @current_node.children << parsed_node
    elsif @root.nil?
      @root = parsed_node
    end
    nil
  end
end
