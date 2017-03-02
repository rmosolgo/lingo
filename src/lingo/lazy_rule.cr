require "./rule"

class LazyRule < Lingo::Rule
  alias RuleGenerator = Proc(Lingo::Rule)
  @inner_rule : Lingo::Rule?

  def initialize(&rule_generator : RuleGenerator)
    @rule_generator = rule_generator
  end

  def parse?(raw_input)
    inner_rule.parse?(raw_input)
  end

  def named(name)
    inner_rule.named(name)
  end

  private def inner_rule
    @inner_rule ||= @rule_generator.call
  end
end
