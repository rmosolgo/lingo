# Lingo

A parser generator for Crystal, inspired by Parslet.

## TODO

- [ ] `parse?` consumes string & pushes nodes as it sees fit, returns True/False for whether it was a success
 - `Context#add_child` adds a child if there's a current node, otherwise no-op
- [ ] not-predicate (!)
- [ ] and-predicate (&)
- [ ] repeat (+, *)
- [ ] optional (?)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  lingo:
    github: rmosolgo/lingo
```

## Usage

```crystal
require "lingo"
```
