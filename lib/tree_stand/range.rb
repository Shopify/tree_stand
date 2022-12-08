module TreeStand
  class Range
    Point = Struct.new(:row, :column)

    attr_reader :start_byte, :end_byte, :start_point, :end_point

    def initialize(start_byte:, end_byte:, start_point:, end_point:)
      @start_byte = start_byte
      @end_byte = end_byte
      @start_point = Point.new(start_point.row, start_point.column)
      @end_point = Point.new(end_point.row, end_point.column)
    end

    def ==(other)
      return false unless other.is_a?(TreeStand::Range)

      @start_byte == other.start_byte &&
        @end_byte == other.end_byte &&
        @start_point == other.start_point &&
        @end_point == other.end_point
    end
  end
end
