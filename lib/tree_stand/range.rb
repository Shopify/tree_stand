# frozen_string_literal: true
# typed: true

module TreeStand
  # Wrapper around a TreeSitter range. This is mainly used to compare ranges.
  class Range
    extend T::Sig

    sig { returns(Integer) }
    attr_reader :start_byte
    sig { returns(Integer) }
    attr_reader :end_byte
    sig { returns(TreeSitter::Point) }
    attr_reader  :start_point
    sig { returns(TreeSitter::Point) }
    attr_reader  :end_point

    # @api private
    sig do
      params(
        start_byte: Integer,
        end_byte: Integer,
        start_point: TreeSitter::Point,
        end_point: TreeSitter::Point,
      ).void
    end
    def initialize(start_byte:, end_byte:, start_point:, end_point:)
      @start_byte = start_byte
      @end_byte = end_byte
      @start_point = start_point
      @end_point = end_point
    end

    sig { params(other: Object).returns(T::Boolean) }
    def ==(other)
      return false unless other.is_a?(TreeStand::Range)

      @start_byte == other.start_byte &&
        @end_byte == other.end_byte &&
        @start_point == other.start_point &&
        @end_point == other.end_point
    end
  end
end
