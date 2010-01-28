require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::TestRunnerTest < Test::Unit::TestCase
  
  def setup
    @test_runner = GUnit::TestRunner.instance
    @test_runner.reset
    io = Object.new
    @test_runner.io = io
    @test_runner.io.stubs(:print)
    @test_runner.io.stubs(:puts)
  end

  def test_it_is_a_test_runner
    assert @test_runner.is_a?(GUnit::TestRunner)
  end

  def test_singleton
    assert_raise NoMethodError do; @test_runner.new; end
    tests = [GUnit::TestSuite.new, GUnit::TestCase.new]
    assert @test_runner.tests != tests
    @test_runner.tests = tests
    assert @test_runner.tests == tests
    @test_runner = GUnit::TestRunner.instance
    assert @test_runner.tests == tests
  end

  def test_tests_getter_setter
    tests = [GUnit::TestSuite.new, GUnit::TestCase.new]
    assert @test_runner.tests != tests
    @test_runner.tests = tests
    assert @test_runner.tests == tests
  end

  def test_patterns_getter_setter
    patterns = ['test/**/*_MY_test.rb', 'test/**/MY_test_*.rb']
    assert @test_runner.patterns != patterns
    @test_runner.patterns = patterns
    assert @test_runner.patterns == patterns
  end

  def test_autorun_getter_setter
    assert @test_runner.autorun?
    @test_runner.autorun = false
    assert ! @test_runner.autorun?
  end

  def test_default_patterns
    assert ! @test_runner.patterns.empty?
    assert_equal GUnit::TestRunner::DEFAULT_PATTERNS, @test_runner.patterns
  end

  def test_discover_tests
    pattern1 = 'foo'
    pattern2 = 'bar'
    file1 = 'foo.rb'
    file2 = 'bar.rb'
    file3 = 'baz.rb'
    @test_runner.patterns = [ pattern1, pattern2 ]
    Dir.expects(:glob).with(pattern1).returns( [ file1, file2 ] ).once
    Dir.expects(:glob).with(pattern2).returns( [ file3 ] ).once
    Kernel.expects(:require).with(file1).returns(true).once
    Kernel.expects(:require).with(file2).returns(true).once
    Kernel.expects(:require).with(file3).returns(true).once
    suite1 = mock
    suite2 = mock
    test_case_subclass1 = mock(:suite => suite1)
    test_case_subclass2 = mock(:suite => suite2)
    GUnit::TestCase.expects(:subclasses).returns([test_case_subclass1, test_case_subclass2])
    @test_runner.discover
    assert @test_runner.tests.include?(suite1)
    assert @test_runner.tests.include?(suite2)
  end
  

  def test_reset_clears_tests_responses_patterns_autorun
    patterns = [ 'test/**/*_MY_test.rb', 'test/**/MY_test_*.rb' ]
    @test_runner.patterns = patterns
    test_response1 = GUnit::PassResponse.new
    test_suite = GUnit::TestSuite.new
    test_suite.expects(:run).multiple_yields(test_response1)
    @test_runner.tests = [test_suite]
    @test_runner.autorun = false
    @test_runner.run
    assert @test_runner.responses.include?(test_response1)
    assert ! @test_runner.tests.empty?
    assert ! @test_runner.responses.empty?
    assert_not_equal GUnit::TestRunner::DEFAULT_PATTERNS, @test_runner.patterns
    @test_runner.reset
    assert @test_runner.autorun?
    assert @test_runner.tests.empty?
    assert @test_runner.responses.empty?
    assert_equal GUnit::TestRunner::DEFAULT_PATTERNS, @test_runner.patterns
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
    @test_runner.reset
    assert @test_runner.io == STDOUT
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
  
  def test_run_bang
    @test_runner.io = mock() # fails if any methods on io are called
    @test_runner.silent = true
    test_response1 = GUnit::PassResponse.new
    test_suite = GUnit::TestSuite.new
    @test_runner.tests = [test_suite]

    test_suite.expects(:run).times(0)
    @test_runner.autorun = false
    @test_runner.run!

    test_suite.expects(:run).times(1).yields(test_response1)
    @test_runner.autorun = true
    @test_runner.run!
  end

  def test_run_not_silent
    test_response1 = GUnit::PassResponse.new
    fail_response_message = "Whoops. Failed."
    fail_line_number = 63
    fail_file_name = 'my_test.rb'
    backtrace = 
    test_response2 = GUnit::FailResponse.new(fail_response_message, ["samples/#{fail_file_name}:#{fail_line_number}:in `my_method'"])
    exception_response_message = "Exceptional"
    exception_line_number = 72
    exception_file_name = 'my_other_test.rb'
    test_response3 = GUnit::ExceptionResponse.new(exception_response_message, ["samples/#{exception_file_name}:#{exception_line_number}:in `my_method'"])
    test_response4 = GUnit::ToDoResponse.new
    @test_runner.silent = false
    io = mock
    io.expects(:print).with(GUnit::TestRunner::PASS_CHAR).at_least(1)
    io.expects(:print).with(GUnit::TestRunner::FAIL_CHAR).at_least(1)
    io.expects(:print).with(GUnit::TestRunner::EXCEPTION_CHAR).at_least(1)
    io.expects(:print).with(GUnit::TestRunner::TODO_CHAR).at_least(1)
    io.stubs(:puts)
    io.expects(:puts).with() { |value| value =~ /#{fail_response_message}/ && value =~ /#{fail_file_name}/ && value =~ /#{fail_line_number}/ }.at_least(1)
    io.expects(:puts).with() { |value| value =~ /#{exception_response_message}/ && value =~ /#{exception_file_name}/ && value =~ /#{exception_line_number}/ }.at_least(1)
    @test_runner.io = io
    
    test_suite = GUnit::TestSuite.new
    test_suite.expects(:run).multiple_yields(test_response1, test_response2, test_response4)
    test_case = GUnit::TestCase.new
    test_case.expects(:run).returns(test_response3)
    @test_runner.tests = [test_suite, test_case]

    @test_runner.run
  end
  
  def test_run_runs_all_tests_saves_responses
    test_response1 = GUnit::PassResponse.new
    test_response2 = GUnit::FailResponse.new
    test_response3 = GUnit::ExceptionResponse.new
    test_response4 = GUnit::ToDoResponse.new
    test_suite = GUnit::TestSuite.new
    test_suite.expects(:run).multiple_yields(test_response1, test_response2, test_response4)
    test_case = GUnit::TestCase.new
    test_case.expects(:run).returns(test_response3)
    @test_runner.tests = [test_suite, test_case]
    
    @test_runner.run
    
    assert @test_runner.responses.include?(test_response1)
    assert @test_runner.passes.include?(test_response1)
    assert @test_runner.responses.include?(test_response2)
    assert @test_runner.fails.include?(test_response2)
    assert @test_runner.responses.include?(test_response3)
    assert @test_runner.exceptions.include?(test_response3)
    assert @test_runner.responses.include?(test_response4)
    assert @test_runner.to_dos.include?(test_response4)
    assert @test_runner.responses.length == 4
  end
  
end
