require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::TestSuiteTest < Test::Unit::TestCase

  def setup
    @test_suite = GUnit::TestSuite.new
  end

  def test_it_is_a_test_suite
    assert @test_suite.is_a?(GUnit::TestSuite)
  end

  def test_tests_getter_setter
    tests = [GUnit::TestSuite.new, GUnit::TestCase.new]
    assert @test_suite.tests != tests
    @test_suite.tests = tests
    assert @test_suite.tests == tests
  end

  def test_tests_set_nil_has_empty_tests
    @test_suite.tests = nil
    assert @test_suite.tests.empty?
    assert @test_suite.tests.is_a?(Enumerable)
  end

end
