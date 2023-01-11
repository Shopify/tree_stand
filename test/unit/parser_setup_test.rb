require "test_helper"

class ParserSetupTest < Minitest::Test
  def test_can_parse_a_sql_statement
    parser = TreeSitter::Parser.new.tap do |parser|
      parser.language = TreeSitter::Language.load("math", "parsers/math.so")
    end

    tree = parser.parse_string(nil, <<~MATH)
      1 + x * 3
    MATH

    query = TreeSitter::Query.new(parser.language, <<~QUERY)
      (expression
        (sum
          left: (number)
          right: (product
            left: (variable)
            right: (number))))
    QUERY
    cursor = TreeSitter::QueryCursor.exec(query, tree.root_node)

    refute_nil(cursor.next_match)
  end

  def test_can_parse_a_sql_statement_with_tree_sit_api
    parser = TreeStand::Parser.new("math")
    tree = parser.parse_string(nil, <<~MATH)
      1 + x * 3
    MATH

    matches = tree.query(<<~QUERY)
      (expression
        (sum
          left: (number)
          right: (product
            left: (variable)
            right: (number))))
    QUERY

    assert_equal(1, matches.size)
  end
end
