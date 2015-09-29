class Lingo::Token
  getter :value, :remainder, :name

  def initialize(@value="", @remainder="", @name=:__anon__)
  end
end
