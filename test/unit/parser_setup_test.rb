require "test_helper"

class ParserSetupTest < Minitest::Test
  def test_can_parse_a_sql_statement
    parser = TreeSitter::Parser.new.tap do |parser|
      parser.language = TreeSitter::Language.load("sql", "parsers/sql.so")
    end

    tree = parser.parse_string(nil, <<~SQL)
      SELECT 1;
    SQL

    query = TreeSitter::Query.new(parser.language, <<~QUERY)
      (program
        (statement
          (select
           (keyword_select)
           (select_expression
             (term value: (literal))))))
    QUERY
    cursor = TreeSitter::QueryCursor.exec(query, tree.root_node)

    refute_nil(cursor.next_match)
  end

  def test_can_parse_a_sql_statement_with_tree_sit_api
    parser = TreeStand::Parser.new("sql")
    tree = parser.parse_string(nil, <<~SQL)
      SELECT 1;
    SQL

    matches = tree.query(<<~QUERY)
      (program
        (statement
          (select
           (keyword_select)
           (select_expression
             (term value: (literal))))))
    QUERY

    assert_equal(1, matches.size)
  end
end
