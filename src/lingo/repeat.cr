class Lingo::Repeat < Lingo::Rule
  def initialize(@inner, @from=0, @to=Float32::INFINITY)
  end

  def parse?(context : Lingo::Context)
    new_context = context.fork
    successes = 0
    while @inner.parse?(new_context)
      successes += 1
    end

    if @from <= successes <= @to
      if new_context.root
        context.join(new_context)
      end
      true
    else
      false
    end
  end
end
