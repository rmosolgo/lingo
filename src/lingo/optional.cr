class Lingo::Optional < Lingo::Constructable
  def initialize(@inner)
  end

  def parse?(raw_input)
    res = @inner.parse?(raw_input)
    if res.is_a?(Lingo::Node)
      res
    else
      nil
    end
  end
end
