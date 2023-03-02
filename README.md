# TreeStand

[![TreeStand](https://github.com/Shopify/tree_stand/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Shopify/tree_stand/actions/workflows/ci.yml)


TreeStand is a high-level Ruby wrapper for the [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) bindings. It
makes it easier to configure the parsers, and work with the underlying syntax tree.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tree_stand"
```

See the [documentation](https://shopify.github.io/tree_stand) for supported features.

## Usage

### Setting Up a Parser

TreeStand does not help with compiling individual parsers. However, once you compile a parser and generate a shared
object (`.so`) or a dynamic library (`.dylib`) you can tell TreeStand where to find them and pass the parser filename
to `TreeStand::Parser::new`.

```ruby
TreeStand.configure do
  config.parser_path = "path/to/parser/folder/"
end

sql_parser = TreeStand::Parser.new("sql")
ruby_parser = TreeStand::Parser.new("ruby")
```


### API Conventions

TreeStand aims to provide APIs similar to TreeSitter when possible. For example, the TreeSitter parser exposes a
`#parse_string(tree, document)` method. TreeStand replicates this behaviour closely with it's `#parse_string(document,
tree: nil)` method but augments it to return a `TreeStand::Tree` instead of the underlying `TreeSitter::Tree`.
Similarly, `TreeStand::Tree#root_node` returns a `TreeStand::Node` & `TreeSitter::Tree#root_node` returns a
`TreeSitter::Node`.

The underlying objects are accessible via a `ts_` prefixed attribute, e.g. `ts_parser`, `ts_tree`, `ts_node`, etc.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Shopify/tree_stand. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TreeStand project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Shopify/tree_stand/blob/master/CODE_OF_CONDUCT.md).
