module TreeStand
  class Capture
    attr_reader :match, :ts_capture

    def initialize(match, ts_capture)
      @match = match
      @ts_capture = ts_capture
    end

    def name
      @match.ts_query.capture_name_for_id(@ts_capture.index)
    end

    def node
      TreeStand::Node.new(@match.tree, @ts_capture.node)
    end

    def ==(other)
      return false unless other.is_a?(TreeStand::Capture)

      name == other.name &&
        node == other.node
    end
  end
end
