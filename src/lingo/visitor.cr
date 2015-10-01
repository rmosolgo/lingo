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
      enter_handlers = @@enter_handlers[node_name]

      # puts "Enter #{node_name}: #{enter_handlers.size}"
      if enter_handlers.is_a?(HandlerList)
        enter_handlers.each do |handler|
          handler.call(node)
        end
      end

      node.children.each do |child_node|
        visit_node(child_node)
      end

      exit_handlers = @@exit_handlers[node_name]

      # puts "Exit #{node_name}: #{exit_handlers.size}"
      if exit_handlers.is_a?(HandlerList)
        exit_handlers.each do |handler|
          handler.call(node)
        end
      end
    end

    nil
  end
end
