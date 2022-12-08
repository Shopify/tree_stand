module TreeStand
  class Parser
    attr_reader :ts_language

    def initialize(language_string)
      @language_string = language_string
      @ts_language = TreeSitter::Language.load(
        language_string,
        "#{TreeStand.config.parser_path}/#{language_string}.so"
      )
      @ts_parser = TreeSitter::Parser.new.tap do |parser|
        parser.language = @ts_language
      end
    end

    def parse_string(tree, string)
      # There's a bug with passing a non-nil tree
      ts_tree = @ts_parser.parse_string(nil, string)
      TreeStand::Tree.new(self, ts_tree, string)
    end
  end
end
