require "test_helper"

class VisitorTest < Minitest::Test
  def setup
    @parser = TreeStand::Parser.new("math")
  end

  def test_on_default
    tree = @parser.parse_string(<<~MATH)
      1 + x * 3
    MATH

    acc = []

    visitor = TreeStand::Visitor.new(tree.root_node)
    visitor.define_singleton_method(:_on_default) { |node| acc << node.type }
    visitor.visit

    assert_equal(
      %i(expression sum number + product variable * number),
      acc,
    )
  end

  def test_custom_visitor_hooks
    tree = @parser.parse_string(<<~MATH)
      1 + x * 3
    MATH

    acc = []

    method = ->(node) { acc << node.type }
    visitor = TreeStand::Visitor.new(tree.root_node)
    visitor.define_singleton_method(:on_sum, method)
    visitor.define_singleton_method(:on_number, method)
    visitor.define_singleton_method(:on_expression, method)
    visitor.visit

    assert_equal(
      %i(expression sum number number),
      acc,
    )
  end
end
