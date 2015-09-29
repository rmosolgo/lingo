class Lingo::OrderedChoice
  include Lingo::Constructable

  property :name

  def initialize(@first : Rule, @second : Rule)
  end

  macro first_then_second(method_name)
    def {{method_name}}(raw_input)
      @first.{{method_name}}(raw_input) || @second.{{method_name}}(raw_input)
    end
  end

  first_then_second parse
  first_then_second matches?
end
