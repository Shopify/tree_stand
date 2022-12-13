require "tree_sitter"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

# TreeStand is a high-level Ruby wrapper for {https://tree-sitter.github.io/tree-sitter tree-sitter} bindings. It makes
# it easier to configure the parsers, and work with the underlying syntax tree.
module TreeStand
  # Common Ancestor for all TreeStand errors.
  class Error < StandardError; end

  class << self
    # Easy configuration of the gem.
    #
    # @example
    #   TreeStand.configure do
    #     config.parser_path = "path/to/parser/folder/"
    #   end
    #
    #   sql_parser = TreeStand::Parser.new("sql")
    #   ruby_parser = TreeStand::Parser.new("ruby")
    # @return [void]
    def configure(&block)
      instance_eval(&block)
    end

    # @return [TreeStand::Config]
    def config
      @config ||= Config.new
    end
  end
end
