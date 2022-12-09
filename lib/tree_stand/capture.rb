module TreeStand
  # Wrapper around a TreeSitter capture.
  # @see TreeStand::Tree#query
  # @see TreeStand::Match
  class Capture
    # @return [TreeStand::Match]
    attr_reader :match
    # @return [TreeSitter::Capture]
    attr_reader :ts_capture

    # @api private
    def initialize(match, ts_capture)
      @match = match
      @ts_capture = ts_capture
    end

    # The name of the capture. TreeSitter strips the `@` from the capture name.
    # @example
    #   match = @tree.query(<<~QUERY).first
    #     (identifier) @identifier.name
    #   QUERY
    #
    #   capture = match.captures.first
    #
    #   assert_equal("identifier.name", capture.name)
    # @return [String]
    def name
      @match.ts_query.capture_name_for_id(@ts_capture.index)
    end

    # @return [TreeStand::Node]
    def node
      TreeStand::Node.new(@match.tree, @ts_capture.node)
    end

    # @param other [Object]
    # @return [bool]
    def ==(other)
      return false unless other.is_a?(TreeStand::Capture)

      name == other.name &&
        node == other.node
    end
  end
end
