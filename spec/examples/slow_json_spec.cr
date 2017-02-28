require "../spec_helper"

describe "SlowJSON" do
  it "parses JSON" do
    input = %{{
      "a" : 1,
      "b" : true,
      "c" : false,
      "d":null,
      "e" : 3.321,
      "f": { "f1": "f2"},
      "g": [1, null, {"h": "str"}]
    }}
    res = SlowJSON.parse(input)

    expected = {
      "a" => 1,
      "b" => true,
      "c" => false,
      "d" => nil,
      "e" => 3.321,
      "f" => {"f1" => "f2"},
      "g" => [1, nil, {"h" => "str"}],
    }

    res.should eq(expected)
  end
end
