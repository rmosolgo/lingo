class Lingo::Node
  getter :value, :remainder, :children
  property :name

  def initialize(@value="", @remainder="", @children=[] of Lingo::Node)
  end

  def rule_name
    :node
  end

  def to_s
    "<#{self.class.name} value='#{value}' remainder='#{remainder}' children=(#{children.size})>"
  end

  def chain(constructor)
    constructor.new(value: @value, remainder: @remainder, children: [self])
  end
end
