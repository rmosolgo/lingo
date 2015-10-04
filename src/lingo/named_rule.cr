require "./rule"

class Lingo::NamedRule < Lingo::Rule
  def initialize(@name, @inner)
  end

  def parse?(context : Lingo::Context)
    new_root = Lingo::Node.new(name: @name)
    new_context = context.fork(root: new_root)
    success = @inner.parse?(new_context)
    if success
      context.join(new_context)
      true
    else
      false
    end
  end
end
