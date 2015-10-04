require "./rule"

class Lingo::OrderedChoice < Lingo::Rule
  alias Choices = Array(Lingo::Rule)
  getter :choices

  def initialize(incoming_choices=Choices.new, @name=nil)
    new_choices = Choices.new
    incoming_choices.each do |incoming_choice|
      if incoming_choice.responds_to?(:choices)
        new_choices += incoming_choice.choices
      else
        new_choices << incoming_choice
      end
    end
    @choices = new_choices
  end

  def parse?(context : Lingo::Context)
    next_context = context.fork
    choices.each do |choice|
      if choice.parse?(next_context)
        break
      end
    end
    next_result = next_context.root
    if next_result.is_a?(Lingo::Node)
      if @name
        next_result.name = @name
      end
      context.join(next_context)
      true
    else
      false
    end
  end

  def as(name)
    self.class.new(@choices, name: name)
  end
end
