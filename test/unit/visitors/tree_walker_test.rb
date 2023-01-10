require "test_helper"

module Visitors
  class TreeWalkerTest < Minitest::Test
    def setup
      @parser = TreeStand::Parser.new("sql")
    end

    def test_walk_whole_tree
      tree = @parser.parse_string(nil, <<~SQL)
        SELECT 1;
      SQL

      node_types = []
      visitor = TreeStand::Visitors::TreeWalker.new(tree.root_node) do |node|
        node_types << node.type
      end.visit

      assert_equal(
        %i(program statement select keyword_select select_expression term literal ;),
        node_types
      )
    end

    def test_tree_api_walks_the_whole_tree
      tree = @parser.parse_string(nil, <<~SQL)
        SELECT 1;
      SQL

      node_types = []
      tree.each do |node|
        node_types << node.type
      end

      assert_equal(
        %i(program statement select keyword_select select_expression term literal ;),
        node_types
      )

      assert(tree.any? { |node| node.type == :keyword_select })
    end

    def test_node_api_walks_the_whole_tree
      tree = @parser.parse_string(nil, <<~SQL)
        SELECT 1;
      SQL

      node_types = []
      tree.root_node.walk do |node|
        node_types << node.type
      end


      assert_equal(
        %i(program statement select keyword_select select_expression term literal ;),
        node_types
      )

      assert(tree.root_node.walk.any? { |node| node.type == :keyword_select })
    end
  end
end
