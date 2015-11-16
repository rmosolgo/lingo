# Lingo [![Build Status](https://travis-ci.org/rmosolgo/lingo.svg)](https://travis-ci.org/rmosolgo/lingo)

A parser generator for Crystal, inspired by [Parslet](https://github.com/kschiess/parslet).

Lingo provides text processing by:
- parsing the string into a tree of nodes
- providing a visitor to allow you to work from the tree

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  lingo:
    github: rmosolgo/lingo
```

## Usage

See examples in `/examples`.

## Development

- Run the __tests__ with `crystal spec`
- Install Ruby & `guard`, then start a __watcher__ with `guard`

## About this Project

### TODO

- [ ] Add some usage notes
- [ ] Add some kind of debug output

### Goals

- Low barrier to entry: easy-to-learn API, short zero-to-working time
- Easy-to-read code, therefore easy-to-modify
- Useful errors (not accomplished)

### Non-goals

- Blazing-fast performance
- Theoretical correctness

### How slow is it?

Let's compare the built-in JSON parser to a Lingo JSON parser:

```
./lingo/benchmark $ crystal run --release slow_json.cr
Stdlib JSON  126.2k (± 1.09%)        fastest
Lingo::JSON 668.61  (± 1.36%) 188.76× slower
```

Ouch, that's __a lot slower__.

But, it's on par with Ruby and `parslet`, the inspiration for this project:

```
$ ruby parslet_json_benchmark.rb
Calculating -------------------------------------
       Parslet JSON      4.000  i/100ms
       Built-in JSON     3.657k i/100ms
-------------------------------------------------
       Parslet JSON      45.788  (± 4.4%) i/s -    232.000
       Built-in JSON     38.285k (± 5.3%) i/s -    193.821k

Comparison:
       Built-in JSON:    38285.2 i/s
       Parslet JSON :       45.8 i/s - 836.13x slower
```

Parslet is relatively slower, but that's to be expected: Parslet provides a better transformation API and better line number tracking.
