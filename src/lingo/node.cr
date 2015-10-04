class Lingo::Node
  getter :value, :children
  property :name

  def initialize(@value="", @children=[] of Lingo::Node)
  end

  def to_s
    "<#{self.class.name} (#{@name}) value='#{value}' children=(#{children.map {|c| c.name as Symbol?}.join(", ")})>"
  end
end
