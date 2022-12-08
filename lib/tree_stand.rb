require "tree_sitter"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module TreeStand
  class Error < StandardError; end

  class << self
    def config
      @config ||= Config.new
    end

    def configure(&block)
      instance_eval(&block)
    end
  end
end
