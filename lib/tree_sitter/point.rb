# frozen_string_literal: true
# typed: true

module TreeSitter
  # Point is a Struct containing the row and column from a TreeSitter point.
  # TreeStand uses this to compare points.
  # @!attribute [rw] row
  #   @return [Integer]
  # @!attribute [rw] column
  #   @return [Integer]
  Point = Struct.new(:row, :column)
end
