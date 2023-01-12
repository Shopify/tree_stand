module TreeStand
  # Wrapper around the TreeSitter parser. It looks up the parser by filename in
  # the configured parsers directory.
  # @example
  #   TreeStand.configure do
  #     config.parser_path = "path/to/parser/folder/"
  #   end
  #
  #   # Looks for a parser in `path/to/parser/folder/sql.{so,dylib}`
  #   sql_parser = TreeStand::Parser.new("sql")
  #
  #   # Looks for a parser in `path/to/parser/folder/ruby.{so,dylib}`
  #   ruby_parser = TreeStand::Parser.new("ruby")
  class Parser
    # @return [TreeSitter::Language]
    attr_reader :ts_language
    # @return [TreeSitter::Parser]
    attr_reader :ts_parser

    # @param language [String]
    def initialize(language)
      @language_string = language
      @ts_language = TreeSitter::Language.load(
        language,
        "#{TreeStand.config.parser_path}/#{language}.so"
      )
      @ts_parser = TreeSitter::Parser.new.tap do |parser|
        parser.language = @ts_language
      end
    end

    # Parse the provided document with the TreeSitter parser.
    # @param tree [TreeStand::Tree]
    # @param document [String]
    # @return [TreeStand::Tree]
    def parse_string(tree, document)
      # There's a bug with passing a non-nil tree
      ts_tree = @ts_parser.parse_string(nil, document)
      TreeStand::Tree.new(self, ts_tree, document)
    end

    # (see #parse_string)
    # @note Like {#parse_string}, except that if the tree contains any parse
    #   errors, raises an {TreeStand::InvalidDocument} error.
    #
    # @see #parse_string
    # @raise [TreeStand::InvalidDocument]
    def parse_string!(tree, document)
      tree = parse_string(tree, document)
      return tree unless tree.any?(&:error?)

      raise(InvalidDocument, <<~ERROR)
        Encountered errors in the document. Check the tree for more details.
          #{tree}
      ERROR
    end
  end
end
