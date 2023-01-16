require "test_helper"

class VersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TreeStand::VERSION
  end

  def test_everything_is_documented
    report = `bundle exec yard stats`
    documented = report.lines.detect { |line| line =~ /% documented/ }

    assert_equal "100.00% documented", documented.strip
  end
end
