require "../spec_helper"

describe "SlowJSON" do
  it "parses JSON" do
    input = %{{"a" : 1 }}
    res = SlowJSON.parse(input)
    puts res
  end
end
