module TreeStand
  class Match
    attr_reader :tree, :ts_query, :ts_match

    def initialize(tree, ts_query, ts_match)
      @tree = tree
      @ts_query = ts_query
      @ts_match = ts_match

      # TODO: This is a hack to get the captures to be populated.
      # See: https://github.com/Faveod/ruby-tree-sitter/pull/16
      captures
    end

    def [](capture_name)
      captures.find { |capture| capture.name == capture_name }
    end

    def dig(name, *)
      self[name]
    end

    def captures
      @captures ||= @ts_match.captures.map do |capture|
        TreeStand::Capture.new(self, capture)
      end
    end

    def ==(other)
      return false unless other.is_a?(TreeStand::Match)

      captures == other.captures
    end
  end
end
