module TreeStand
  # Wrapper around a TreeSitter range. This is mainly used to compare ranges.
  class Range
    # Point is a Struct containing the row and column from a TreeSitter point.
    # TreeStand uses this to compare points.
    # @!attribute [rw] row
    #   @return [Integer]
    # @!attribute [rw] column
    #   @return [Integer]
    Point = Struct.new(:row, :column)

    # @return [Integer]
    attr_reader :start_byte
    # @return [Integer]
    attr_reader :end_byte
    # @return [TreeStand::Range::Point]
    attr_reader  :start_point
    # @return [TreeStand::Range::Point]
    attr_reader  :end_point

    # @api private
    def initialize(start_byte:, end_byte:, start_point:, end_point:)
      @start_byte = start_byte
      @end_byte = end_byte
      @start_point = Point.new(start_point.row, start_point.column)
      @end_point = Point.new(end_point.row, end_point.column)
    end

    # @param other [Object]
    # @return [bool]
    def ==(other)
      return false unless other.is_a?(TreeStand::Range)

      @start_byte == other.start_byte &&
        @end_byte == other.end_byte &&
        @start_point == other.start_point &&
        @end_point == other.end_point
    end
  end
end
