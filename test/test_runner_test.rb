require 'test_helper'

class GUnit::TestRunnerTest < Test::Unit::TestCase
  
  def setup
    @test_runner = GUnit::TestRunner.new
    @test_runner.io.stubs(:print)
    @test_runner.io.stubs(:puts)
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
  
  def test_has_empty_responses
    assert @test_runner.responses.empty?
    assert @test_runner.responses.is_a?(Enumerable)
  end
  
  def test_silent_default
    assert ! @test_runner.silent
  end
  
  def test_silent_getter_setter
    silent = true
    assert @test_runner.silent != silent
    @test_runner.silent = silent
    assert @test_runner.silent === silent
  end
  
  def test_io_default
    assert GUnit::TestRunner.new.io == STDOUT
  end
  
  def test_silent_getter_setter
    io = mock
    assert @test_runner.io != io
    @test_runner.io = io
    assert @test_runner.io === io
  end
  
  def test_run_silent
    @test_runner.io = mock() # fails if any methods on io are called
    @test_runner.silent = true
    test_response1 = GUnit::PassResponse.new    
    test_suite = GUnit::TestSuite.new
    test_suite.expects(:run).yields(test_response1)
    @test_runner.tests = [test_suite]
    @test_runner.run
  end
  
  def test_run_not_silent
    @test_runner.silent = false
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
