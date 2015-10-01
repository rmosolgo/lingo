class Lingo::Node
  getter :value, :children
  property :name

  def initialize(@value="", @children=[] of Lingo::Node)
  end

  def rule_name
    :node
  end

  def to_s
    "<#{self.class.name} value='#{value}' children=(#{children.size})>"
  end

  def chain(constructor)
    constructor.new(value: @value, children: [self])
  end
end
