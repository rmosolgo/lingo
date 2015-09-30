class Lingo::Token
  getter :value, :remainder

  def initialize(@value="", @remainder="")
  end

  def rule_name
    :token
  end
end
