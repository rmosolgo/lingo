class Lingo::Parser
  def initialize
    @rules = {} of Symbol => Lingo::Constructable
  end

  macro str(match)
    Lingo::Terminal.new({{match}})
  end

  macro rule(rule_name, &block)
    class {{rule_name.camelcase.id}}Node < Lingo::Node
    end

    def {{rule_name.id}}
      @rules[{{rule_name}}] ||= begin
        rule = {{block.body}}
        rule.node_constructor = {{rule_name.camelcase.id}}Node
        rule
      end
    end
  end

  macro root(rule_name)
    def parse(raw_input)
      {{rule_name.id}}.parse(raw_input)
    end
  end
end
