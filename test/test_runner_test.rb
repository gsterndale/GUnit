require 'test_helper'

class GUnit::TestRunnerTest < Test::Unit::TestCase
  
  def setup
    @test_runner = GUnit::TestRunner.new
  end
  
  def test_it_is_a_test_runner
    assert @test_runner.is_a?(GUnit::TestRunner)
  end
  
  def test_tests_getter_setter
    tests = [GUnit::TestSuite.new, GUnit::TestCase.new]
    assert @test_runner.tests != tests
    @test_runner.tests = tests
    assert @test_runner.tests == tests
  end
  
  def test_tests_set_nil_has_empty_tests
    @test_runner.tests = nil
    assert @test_runner.tests.empty?
    assert @test_runner.tests.is_a?(Enumerable)
  end
  
  def test_run_runs_all_tests
    suite1 = mock
    suite1.expects(:run)
    suite2 = mock
    suite2.expects(:run)
    @test_runner.tests = [suite1, suite2]
    @test_runner.run
  end
  
end
