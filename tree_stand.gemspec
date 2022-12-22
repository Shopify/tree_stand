lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tree_stand/version"

Gem::Specification.new do |spec|
  spec.name          = "tree_stand"
  spec.version       = TreeStand::VERSION
  spec.authors       = ["derekstride"]
  spec.email         = ["derek@stride.host", "opensource@shopify.com"]

  spec.summary       = "A high-level Ruby wrapper for the Tree-sitter bindings"
  spec.homepage      = "https://github.com/Shopify/tree_stand"
  spec.license       = "MIT"

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => spec.homepage,
    "documentation_uri" => "https://shopify.github.io/tree_stand",
  }

  spec.extensions = ["ext/tree_stand/extconf.rb"]

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rb_sys"
  spec.add_dependency "ruby_tree_sitter"
  spec.add_dependency "sorbet-runtime"
  spec.add_dependency "zeitwerk"
end
