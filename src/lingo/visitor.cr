require "./node"

class Lingo::Visitor
  macro create_registry
    HandlerRegistry.new do |h, k|
      new_list = HandlerList.new
      h[k] = new_list
    end
  end

  macro inherited
    @@enter_handlers : HandlerRegistry
    @@exit_handlers : HandlerRegistry

    alias Handler = Lingo::Node, self -> Nil
    alias HandlerList = Array(Handler)
    alias HandlerRegistry = Hash(Symbol, HandlerList)

    @@enter_handlers = create_registry
    @@exit_handlers = create_registry
  end

  macro enter(rule_name, &block)
    @@enter_handlers[{{rule_name}}] << Handler.new { |node, visitor|
      {{block.body}}
      next nil
    }
  end

  macro exit(rule_name, &block)
    @@exit_handlers[{{rule_name}}] << Handler.new { |node, visitor|
      {{block.body}}
      next nil
    }
  end

  # Depth-first visit this node & children,
  # calling handlers along the way.
  def visit(node)
    apply_visitation(node)
  end

  private def apply_visitation(node)
    node_name = node.name

    if node_name.is_a?(Symbol)
      # p "Enter: #{node_name} : #{node.full_value}"
      enter_handlers = @@enter_handlers[node_name]
      apply_handers(node, enter_handlers)
    end

    node.children.each do |child_node|
      apply_visitation(child_node)
    end

    if node_name.is_a?(Symbol)
      # p "Exit: #{node_name} : #{node.full_value}"
      exit_handlers = @@exit_handlers[node_name]
      apply_handers(node, exit_handlers)
    end

    nil
  end

  private def apply_handers(node : Lingo::Node, handlers)
    handlers.each do |handler|
      handler.call(node, self)
    end
  end
end
