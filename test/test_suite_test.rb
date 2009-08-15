require 'test_helper'

class GUnit::TestSuiteTest < Test::Unit::TestCase
  
  def setup
    @my_test_suite = GUnit::TestSuite.new
  end
  
  def test_it_is_a_test_suite
    assert @my_test_suite.is_a?(GUnit::TestSuite)
  end
  
end
