class Lingo::PatternTerminal < Lingo::Rule
  def initialize(pattern : Regex)
    pat_string = pattern.to_s
    @pattern = Regex.new("^#{pat_string}")
  end

  def parse?(context : Lingo::Context)
    success = false
    context.remainder.match(@pattern) do |match_data|
      success = true
      match_string = match_data[0]
      match_node = Lingo::Node.new(value: match_string)
      context.push_node(match_node)
      context.consume(match_string)
    end
    success
  end
end
