class Lingo::Token
  getter :value, :remainder

  def initialize(@value="", @remainder="")
  end
end
