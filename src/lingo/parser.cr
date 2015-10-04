class Lingo::Parser
  def initialize
    @rules = {} of Symbol => Lingo::Rule
  end

  macro str(match)
    Lingo::Terminal.new({{match}})
  end

  macro rule(rule_name, &block)
    class {{rule_name.camelcase.id}}Node < Lingo::Node
      def rule_name
        {{rule_name}}
      end
    end

    def {{rule_name.id}}
      @rules[{{rule_name}}] ||= begin
        rule = {{block.body}}
        rule
      end
    end
  end

  macro root(rule_name)
    def root
      @root ||= {{rule_name.id}}.as({{rule_name}})
    end

    def parse(raw_input)
      root.parse(raw_input)
    end
  end
end
