require "test_helper"

class NodeTest < Minitest::Test
  def setup
    @parser = TreeStand::Parser.new("sql")
    @tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1;
    SQL
  end

  def test_can_enumerate_children
    program = @tree.root_node
    assert_equal(:program, program.type)

    statement = program.first
    assert_equal(:statement, statement.type)

    select = statement.first
    assert_equal(:select, select.type)

    assert_equal(2, select.count)

    keyword, select_expr = select.to_a
    assert_equal(:keyword_select, keyword.type)
    assert_equal(:select_expression, select_expr.type)

    term = select_expr.first
    assert_equal(:term, term.type)

    literal = term.first
    assert_equal(:literal, literal.type)
  end

  def test_can_delegate_named_fields
    term_node = @tree.root_node.first.first.to_a.last.first

    assert_equal(:literal, term_node.value.type)
    assert_equal("1", term_node.value.text)
  end


  def test_can_navigate_to_the_parent_nodes
    node = @tree.root_node.first.first

    assert_equal(:program, node.parent.parent.type)
    assert_equal(@tree.root_node, node.parent.parent)
  end

  def test_nodes_wrap_the_document_so_they_can_reference_text
    assert_equal(<<~SQL, @tree.root_node.text)
      SELECT 1;
    SQL

    keyword, expr = @tree.root_node.first.first.to_a
    assert_equal("SELECT", keyword.text)
    assert_equal("1", expr.text)
  end

  def test_nodes_wrap_range_in_a_comparable_struct
    assert_instance_of(TreeStand::Range, @tree.root_node.range)
  end
end
