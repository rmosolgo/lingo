class Lingo::Node
  getter :value, :children, :line, :column
  property :name

  def initialize(@value="", @children=[] of Lingo::Node, @name=nil, @line=0, @column=0)
  end

  def to_s
    "<#{self.class.name} (#{@name}) value='#{value}' children=(#{children.map {|c| c.name.inspect as String}.join(", ")})>"
  end

  def full_value
    @value + children.map { |c| c.full_value as String }.join("")
  end
end
