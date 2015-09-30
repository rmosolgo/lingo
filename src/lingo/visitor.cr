class Lingo::Visitor
  alias Handler = Lingo::Token -> Nil

  macro inherited
    @@handlers = {} of Symbol => Handler
  end

  macro visit(name, &block)
    %handler = -> ({{block.args.first.id}} : Lingo::Token ) {
      {{block.body}}
    }


    @@handlers[{{name}}] = Handler.new { |token|
      %handler.call(token)
      nil
    }
  end

  def visit(parse_result)
    puts parse_result
  end
end
