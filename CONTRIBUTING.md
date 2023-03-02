# Contributing to TreeStand

## Getting Started

To work on this gem you'll need the tree-sitter CLI tool. See the [offical
documentation](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md#tree-sitter-cli) for installation
instructions.

Clone the repository and run the setup script.

```
git clone https://github.com/Shopify/tree_stand.git
bin/setup
```

### Testing

```
bundle exec rake test
```

### Typechecking

```
bundle exec srb tc
```

### Documentation

To run the documentation server, execute the following command and open [localhost:8808](http://localhost:8808).

```
$ bundle exec yard server --reload
```

To get statistics about documentation coverage and which items are missing documentation run the following command.

```
$ bundle exec yard stats --list-undoc
Files:          10
Modules:         2 (    0 undocumented)
Classes:        11 (    0 undocumented)
Constants:       1 (    0 undocumented)
Attributes:     14 (    0 undocumented)
Methods:        34 (    0 undocumented)
 100.00% documented
```

## Pushing a new Version

Create a new PR to bump the version number in `lib/tree_stand/version.rb`. See
[github://Shopify/tree_stand#18](https://github.com/Shopify/tree_stand/pull/18) for an example.

```ruby
$ cat lib/tree_stand/version.rb
module TreeStand
  # The current version of the gem.
  VERSION = "0.1.5"
end
```

Once that PR is merged, tag the latest commit with the format `v#{TreeStand::VERSION}` and push the new tag.

```
git tag v0.1.5
git push --tags
```

Draft a new Release [on Github](https://github.com/Shopify/tree_stand/releases).

Finally, we use [shipit](https://github.com/Shopify/shipit-engine) to push gems to rubygems.
