require "test_helper"

class TreeTest < Minitest::Test
  def setup
    @parser = TreeStand::Parser.new("sql")
  end

  def test_can_replace_text
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1
      FROM table
      WHERE foo < 3
        AND bar > 3;
    SQL

    match = tree.query(<<~QUERY).first
      (predicate
        left: (field name: (identifier))
        operator: "<"
        right: (literal)) @foo_lt_3
    QUERY

    node = match["foo_lt_3"].node
    parent = node.parent

    tree.edit(parent.range, parent.right.text)

    assert_equal(<<~SQL, tree.document)
      SELECT 1
      FROM table
      WHERE bar > 3;
    SQL
  end

  def test_can_delete_a_node
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1
      FROM table
      WHERE foo < 3;
    SQL

    match = tree.query(<<~QUERY).first
      (predicate
        left: (field name: (identifier))
        operator: "<"
        right: (literal)) @foo_lt_3
    QUERY

    node = match["foo_lt_3"].node
    parent = node.parent
    grandparent = parent.parent

    tree.delete(grandparent.range)

    assert_equal(<<~SQL, tree.document)
      SELECT 1
      FROM table
      ;
    SQL
  end

  def test_can_edit_an_document_based_an_ast
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1
      FROM table
      WHERE foo < 3
        AND bar > 3
        AND baz = 3;
    SQL

    match = tree.query(<<~QUERY).first
      (predicate
        left: (field name: (identifier))
        operator: "<"
        right: (literal)) @foo_lt_3
    QUERY

    node = match["foo_lt_3"].node
    parent = node.parent

    tree.edit(parent.range, parent.right.text)

    assert_equal(<<~SQL, tree.document)
      SELECT 1
      FROM table
      WHERE bar > 3
        AND baz = 3;
    SQL
  end

  def test_can_edit_an_document_based_an_ast2
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1
      FROM table
      WHERE foo < 3
        AND bar > 3
        AND baz = 3;
    SQL

    match = tree.query(<<~QUERY).first
      (predicate
        left: (field name: (identifier))
        operator: ">"
        right: (literal)) @bar_gt_3
    QUERY

    node = match["bar_gt_3"].node
    parent = node.parent

    tree.edit(parent.range, parent.left.text)

    assert_equal(<<~SQL, tree.document)
      SELECT 1
      FROM table
      WHERE foo < 3
        AND baz = 3;
    SQL
  end

  def test_can_handle_invalid_edits
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1
      FROM table
      WHERE foo < 3
        AND bar > 3
        AND baz = 3;
    SQL

    match = tree.query(<<~QUERY).first
      (table_reference) @table_reference
    QUERY

    table_node = match["table_reference"].node

    match = tree.query(<<~QUERY).first
      (predicate
        left: (field name: (identifier))
        operator: ">"
        right: (literal)) @bar_gt_3
    QUERY

    node = match["bar_gt_3"].node

    tree.edit(node.range, "invalid predicate condition")

    assert_equal(<<~SQL, tree.document)
      SELECT 1
      FROM table
      WHERE foo < 3
        AND invalid predicate condition
        AND baz = 3;
    SQL
  end

  def test_moving_nodes_across_the_tree
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1
      FROM a_table a
      JOIN b_table b
        ON a.id = b.a_id
      WHERE a.c_id = 1
        AND b.d_id = 1
        AND b.c_id = 1
        AND b.e_id = 1;
    SQL

    join_match = tree.query(<<~QUERY)[0]["join"]
      (join (predicate) @join)
    QUERY

    query = <<~QUERY
      (predicate
        (field name: (identifier) @field_name))
    QUERY

    duplicate_fields = tree.query(query)
      .group_by { |m| m["field_name"].node.text }
      .select { |_, matches| matches.size > 1 }

    duplicate_fields.each do |field_name, matches|
      matches.each do |match|
        # Skip the driving table, it'll be left in the where clause
        next if match["field_name"].node.parent.table_alias.text == "a"

        # Save the text for the JOIN because we'll be deleting the original predicate
        text = join_match.node.text +
          " AND a.#{match["field_name"].node.text} = " +
          match["field_name"].node.parent.text

        # Replace the grandparent predicate with the left predicate.
        # e.g. a.c_id = 1
        tree.edit(
          match["field_name"].node.parent.parent.parent.range,
          match["field_name"].node.parent.parent.parent.left.text,
        )

        # Replace the JOIN predicate with the new text
        tree.edit(join_match.node.range, text)
      end
    end

    assert_equal(<<~SQL, tree.document)
      SELECT 1
      FROM a_table a
      JOIN b_table b
        ON a.id = b.a_id AND a.c_id = b.c_id
      WHERE a.c_id = 1
        AND b.d_id = 1
        AND b.e_id = 1;
    SQL
  end
end
