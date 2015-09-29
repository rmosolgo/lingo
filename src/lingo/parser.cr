class Lingo::Parser
  def initialize
    @rules = {} of Symbol => Lingo::Rule
  end

  macro str(match)
    Lingo::Terminal.new({{match}})
  end

  macro rule(name, &block)
    def {{name.id}}
      @rules[{{name}}] ||= begin
        rule = {{block.body}}
        rule.name = {{name}}
        rule
      end
    end
  end

  macro root(name)
    def parse(raw_input)
      {{name.id}}.parse(raw_input)
    end
  end
end
