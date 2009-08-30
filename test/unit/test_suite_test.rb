require 'test_helper'

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
  
  def test_run_runs_all_tests_saves_responses
    test_response1 = GUnit::PassResponse.new
    test_response2 = GUnit::FailResponse.new
    test_response3 = GUnit::ExceptionResponse.new

    test_suite = GUnit::TestSuite.new
    test_suite.expects(:run).multiple_yields(test_response1, test_response2)

    test_case = GUnit::TestCase.new
    test_case.expects(:run).returns(test_response3)

    @test_suite.tests = [test_suite, test_case]

    responses = []
    @test_suite.run{|r| responses << r }
    
    assert responses.include?(test_response1)
    assert responses.include?(test_response2)
    assert responses.include?(test_response3)
    assert responses.length == 3
  end
  
end
