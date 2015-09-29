class Lingo::Visitor
  macro visit(matches, &block)
    puts {{matches.to_a.map { |pair| "#{pair[0].id}=#{pair[1].id}" }.join(", ").id}}
    def apply_transform({{matches.to_a.map { |pair| "#{pair[0].id}=#{pair[1].id}" }.join(", ").id}})

    end
  end

  def visit(parse_result)

  end
end
