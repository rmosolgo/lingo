class Lingo::Node
  def initialize(@match)
  end

  def value
    @match.value
  end

  def remainder
    @match.remainder
  end
end
