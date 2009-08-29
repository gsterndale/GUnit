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
  
  def test__has_empty_responses
    assert @test_runner.responses.empty?
    assert @test_runner.responses.is_a?(Enumerable)
  end
  
  def test_run_runs_all_tests_saves_responses
    test_response1 = GUnit::PassResponse.new
    test_response2 = GUnit::FailResponse.new
    test_response3 = GUnit::ExceptionResponse.new
    test_suite = GUnit::TestSuite.new
    test_suite.expects(:run).multiple_yields(test_response1, test_response2)
    test_case = GUnit::TestCase.new
    test_case.expects(:run).returns(test_response3)
    @test_runner.tests = [test_suite, test_case]
    @test_runner.run
    assert @test_runner.responses.include?(test_response1)
    assert @test_runner.responses.include?(test_response2)
    assert @test_runner.responses.include?(test_response3)
    assert @test_runner.responses.length == 3
  end
  
end
