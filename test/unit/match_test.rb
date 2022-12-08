require "test_helper"

class MatchTest < Minitest::Test
  def setup
    @parser = TreeStand::Parser.new("sql")
    @tree = @parser.parse_string(nil, <<~SQL)
      SELECT 1
      FROM table
      WHERE foo < 3
        AND bar > 3;
    SQL
  end

  def test_single_match
    matches = @tree.query(<<~QUERY)
      (predicate
        left: (field name: (identifier))
        operator: "<"
        right: (literal))
    QUERY

    assert_equal(1, matches.length)
    assert_predicate(matches.first.captures, :empty?)
  end

  def test_multiple_matches
    matches = @tree.query(<<~QUERY)
      (predicate
        left: (field name: (identifier))
        right: (literal))
    QUERY

    assert_equal(2, matches.length)

    matches.map(&:captures).each do |captures|
      assert_predicate(captures, :empty?)
    end
  end

  def test_single_match_with_capture
    matches = @tree.query(<<~QUERY)
      (predicate
        left: (field name: (identifier))
        operator: "<"
        right: (literal)) @foo_lt_3
    QUERY

    assert_equal(1, matches.length)
    assert_equal(1, matches.first.captures.size)
    assert_equal("foo < 3", matches.dig(0, "foo_lt_3").node.text)
  end

  def test_mutliple_matches_with_captures
    matches = @tree.query(<<~QUERY)
      (predicate
        left: (field name: (identifier))
        right: (literal)) @field_op_literal
    QUERY

    assert_equal(2, matches.length)

    matches.map(&:captures).each do |captures|
      assert_equal(1, captures.size)
    end

    assert_equal("foo < 3", matches.dig(0, "field_op_literal").node.text)
    assert_equal("bar > 3", matches.dig(1, "field_op_literal").node.text)
  end

  def test_match_with_multiple_captures
    match = @tree.query(<<~QUERY).first
      (predicate
        left: (field name: (identifier) @field)
        operator: "<" @op
        right: (literal) @value) @foo_lt_3
    QUERY

    assert_equal(4, match.captures.size)
    assert_equal("foo", match["field"].node.text)
    assert_equal("<", match["op"].node.text)
    assert_equal("3", match["value"].node.text)
    assert_equal("foo < 3", match["foo_lt_3"].node.text)
  end
end
