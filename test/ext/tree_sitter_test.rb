require "test_helper"

class TreeSitterTest < Minitest::Test
  def test_loads_the_rust_extension
    assert_equal(5, distance([0, 0], [3, 4]))
  end
end
