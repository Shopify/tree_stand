require "test_helper"

class RangeTest < Minitest::Test
  def setup
    @parser = TreeStand::Parser.new("sql")
  end

  def test_range_equality
    document = <<~SQL
      SELECT 1;
    SQL
    tree = @parser.parse_string(nil, document)

    range = TreeStand::Range.new(
      start_byte: 0,
      end_byte: document.length,
      start_point: TreeStand::Range::Point.new(0, 0),
      end_point: TreeStand::Range::Point.new(1, 0),
    )

    assert_equal(tree.root_node.range, range)
  end
end
