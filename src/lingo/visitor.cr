require "./node"

class Lingo::Visitor
  alias Handler = Lingo::Node -> Nil
  alias HandlerList = Array(Handler)
  alias HandlerRegistry = Hash(Symbol, HandlerList)

  macro create_registry
    HandlerRegistry.new do |h, k|
      new_list = HandlerList.new
      h[k] = new_list
    end
  end

  macro inherited
    @@enter_handlers = create_registry
    @@exit_handlers = create_registry
  end


  macro enter(rule_name, &block)
    %handler = Handler.new { |node|
      {{block.body}}
      nil
    }
    @@enter_handlers[{{rule_name}}] << %handler
  end

  macro exit(rule_name, &block)
    %handler = Handler.new { |node|
      {{block.body}}
      nil
    }
    @@exit_handlers[{{rule_name}}] << %handler
  end

  # Depth-first visit this node & children,
  # calling handlers along the way.
  def visit_node(node)
    node_name = node.name

    if node_name.is_a?(Symbol)
      p "Enter: #{node_name}"
      enter_handlers = @@enter_handlers[node_name]
      apply_handers(node, enter_handlers)
    end

    node.children.each do |child_node|
      visit_node(child_node)
    end

    if node_name.is_a?(Symbol)
      p "Exit: #{node_name}"
      exit_handlers = @@exit_handlers[node_name]
      apply_handers(node, exit_handlers)
    end

    nil
  end

  private def apply_handers(node : Lingo::Node, handlers : HandlerList)
    handlers.each do |handler|
      handler.call(node)
    end
  end
end
