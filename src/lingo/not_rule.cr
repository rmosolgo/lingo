require "./rule"

class Lingo::NotRule < Lingo::Rule
  def initialize(@inner : Lingo::Rule)
  end

  def parse?(context : Lingo::Context)
    new_context = context.fork
    success = @inner.parse?(new_context)

    if success
      # This rule was matched, but shouldn't have been
      false
    else
      # This rule WASNT matched, 🎉
      true
    end
  end
end
