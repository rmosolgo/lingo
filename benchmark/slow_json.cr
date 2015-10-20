require "../examples/slow_json"
require "benchmark"
require "json"

JSON_TEXT = File.read("./mtg_json.json")

Benchmark.ips do |x|
  x.report("Stdlib JSON") { JSON.parse(JSON_TEXT)  }
  x.report("Lingo::JSON") { SlowJSON.parse(JSON_TEXT) }
end
