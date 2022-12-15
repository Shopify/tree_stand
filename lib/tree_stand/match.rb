module TreeStand
  # Wrapper around a TreeSitter match.
  # @see TreeStand::Tree#query
  # @see TreeStand::Node#query
  # @see TreeStand::Capture
  class Match
    # @return [TreeStand::Tree]
    attr_reader :tree
    # @return [TreeSitter::Query]
    attr_reader :ts_query
    # @return [TreeSitter::Match]
    attr_reader :ts_match
    # @return [Array<TreeStand::Capture>]
    attr_reader :captures

    # @api private
    def initialize(tree, ts_query, ts_match)
      @tree = tree
      @ts_query = ts_query
      @ts_match = ts_match

      # It's important to load all of the captures when a Match is
      # instantiated, otherwise the ts_match will be invalid after
      # TreeSitter::Cursor#next_match is called.
      #
      # See: https://github.com/Faveod/ruby-tree-sitter/pull/16
      @captures = @ts_match.captures.map do |capture|
        TreeStand::Capture.new(self, capture)
      end
    end

    # Looks up a capture by name. TreeSitter strips the `@` from the capture name.
    # @example
    #   match = @tree.query(<<~QUERY).first
    #     (identifier) @identifier.name
    #   QUERY
    #
    #   refute_nil(match["identifier.name"])
    # @param capture_name [String] The name of the capture from the query.
    # @return [TreeStand::Capture, nil]
    def [](capture_name)
      captures.find { |capture| capture.name == capture_name }
    end

    # @param other [Object]
    # @return [bool]
    def ==(other)
      return false unless other.is_a?(TreeStand::Match)

      captures == other.captures
    end

    # @return [TreeStand::Capture, nil]
    def dig(name, *)
      self[name]
    end
  end
end
