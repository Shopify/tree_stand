require "test_helper"

class AstModifierTest < Minitest::Test
  def setup
    @parser = TreeStand::Parser.new("sql")
  end

  def test_can_work_with_multiple_edits
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1
      FROM table
      WHERE foo < 3
        AND bar > 3
        AND foobar < 3
        AND baz = 3;
    SQL

    TreeStand::AstModifier.new(tree).on_match(<<~QUERY) do |ast, match|
      (predicate
        left: (field name: (identifier))
        operator: "<"
        right: (literal)) @foo_lt_3
    QUERY
      node = match["foo_lt_3"].node
      parent = node.parent

      if parent.left == node
        tree.edit(parent.range, parent.right.text)
      else
        tree.edit(parent.range, parent.left.text)
      end
    end

    assert_equal(<<~SQL, tree.document)
      SELECT 1
      FROM table
      WHERE bar > 3
        AND baz = 3;
    SQL
  end
end
