require "test_helper"

class VisitorTest < Minitest::Test
  def setup
    @parser = TreeStand::Parser.new("sql")
  end

  def test_on_default
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1;
    SQL

    acc = []

    visitor = TreeStand::Visitor.new(tree.root_node)
    visitor.define_singleton_method(:_on_default) { |node| acc << node.type }
    visitor.visit

    assert_equal(
      %i(program statement select keyword_select select_expression term literal ;),
      acc,
    )
  end

  def test_custom_visitor_hooks
    tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1;
    SQL

    acc = []

    method = ->(node) { acc << node.type }
    visitor = TreeStand::Visitor.new(tree.root_node)
    visitor.define_singleton_method(:on_select, method)
    visitor.define_singleton_method(:on_program, method)
    visitor.define_singleton_method(:on_term, method)
    visitor.define_singleton_method(:on_keyword_select, method)
    visitor.visit

    assert_equal(
      %i(program select keyword_select term),
      acc,
    )
  end
end
