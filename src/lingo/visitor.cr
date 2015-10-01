require "./node"

class Lingo::Visitor
  alias Handler = Lingo::Node -> Nil
  alias HandlerList = Array(Handler)
  alias HandlerRegistry = Hash(Symbol, HandlerList)

  # Setup a HandlersRegistry for this new visitor class
  macro inherited
    @@handlers = HandlerRegistry.new do |h, k|
      new_list = HandlerList.new
      h[k] = new_list
    end
  end

  # Register a visitor for `rule_name`.
  # @example
  #   visit(:digit) { puts "You found a digit" }
  macro visit(rule_name, &block)
    %handler = Handler.new { |node|
      {{block.body}}
      nil
    }
    @@handlers[{{rule_name}}] << %handler
  end

  # Depth-first visit this node & children,
  # calling handlers along the way.
  def visit_node(node)
    node_name = node.name

    if node_name.is_a?(Symbol)
      # Get handlers for this
      handlers = @@handlers[node_name]

      node.children.each do |child_node|
        visit_node(child_node)
      end

      puts "Handlers #{node_name}: #{handlers}"
      if handlers.is_a?(HandlerList)
        handlers.each do |handler|
          puts " --- handler"
          handler.call(node)
        end
      end
    else
      puts "Skipping unnamed"
    end

    nil
  end
end
