class Lingo::Parser
  alias RuleGenerator = Proc(Lingo::Rule)
  class LazyRule < Lingo::Rule
    def initialize(&rule_generator : RuleGenerator)
      @rule_generator = rule_generator
    end

    def parse?(raw_input)
      inner_rule.parse?(raw_input)
    end

    def as(name)
      inner_rule.as(name)
    end

    private def inner_rule
      @inner_rule ||= @rule_generator.call
    end
  end

  def initialize
    @rules = {} of Symbol => LazyRule
  end

  macro str(match)
    Lingo::Terminal.new({{match}})
  end

  macro rule(rule_name, &block)
    def {{rule_name.id}}
      @rules[{{rule_name}}] ||= LazyRule.new { ({{block.body}}) as Lingo::Rule }
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
