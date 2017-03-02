class Lingo::Parser
  def initialize
    @rules = {} of Symbol => Lingo::Rule
  end

  macro str(match)
    Lingo::StringTerminal.new({{match}})
  end

  macro match(patt)
    Lingo::PatternTerminal.new({{patt}})
  end

  macro rule(rule_name, &block)
    def {{rule_name.id}}
      @rules[{{rule_name}}] ||= LazyRule.new { ({{block.body}}).as(Lingo::Rule) }
    end
  end

  macro root(rule_name)
    def root
      @root ||= {{rule_name.id}}.named({{rule_name}}).as(Lingo::Rule)
    end

    def parse(raw_input)
      root.parse(raw_input)
    end
  end

  def any
    @rules[:any] ||= match(/./)
  end
end
