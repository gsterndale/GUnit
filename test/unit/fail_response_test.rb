require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::FailResponseTest < Test::Unit::TestCase
  
  def setup
    @fail_response1 = GUnit::FailResponse.new
  end
  
  def test_it_is_a_fail_response
    assert @fail_response1.is_a?(GUnit::FailResponse)
  end
  
  def test_has_default_message
    assert_not_nil @fail_response1.message
    assert @fail_response1.message != ''
  end
  
  def test_has_default_backtrace
    assert_not_nil @fail_response1.backtrace
    assert_equal [], @fail_response1.backtrace
  end
  
  def test_message_setter
    message = "Whoops."
    @fail_response1.message = message
    assert_equal message, @fail_response1.message
  end
  
  def test_backtrace_setter
    backtrace = ['a', 'b', 'c']
    @fail_response1.backtrace = backtrace
    assert_equal backtrace, @fail_response1.backtrace
  end
  
  # FailResponse.new('my fixtures')
  def test_initialize_with_string
    message = 'Uhohs'
    @fail_response2 = GUnit::FailResponse.new(message)
    assert @fail_response2.message === message
  end
  
  def test_initialize_with_array
    backtrace = ['a', 'b', 'c']
    @fail_response2 = GUnit::FailResponse.new(backtrace)
    assert_equal backtrace, @fail_response2.backtrace
  end
  
  def test_initialize_with_string_and_array
    message = 'Uhohs'
    backtrace = ['a', 'b', 'c']
    @fail_response2 = GUnit::FailResponse.new(message, backtrace)
    assert_equal backtrace, @fail_response2.backtrace
    assert @fail_response2.message === message
  end
  
  def test_line_number
    assert_nil @fail_response1.line_number
    
    line_number = 63
    backtrace = ["./samples/../lib/gunit/assertions.rb:23:in `assert'",
      "./samples/../lib/gunit/assertions.rb:79:in `assert_raises'",
      "samples/foo_sample.rb:#{line_number}:in `__bind_1264219445_661068'",
      "./samples/../lib/gunit/verification.rb:19:in `call'",
      "./samples/../lib/gunit/verification.rb:19:in `run'",
      "./samples/../lib/gunit/test_case.rb:108:in `test_not_exceptional'",
      "./samples/../lib/gunit/test_case.rb:38:in `send'",
      "./samples/../lib/gunit/test_case.rb:38:in `run'",
      "./samples/../lib/gunit/test_suite.rb:21:in `run'",
      "./samples/../lib/gunit/test_suite.rb:16:in `each'",
      "./samples/../lib/gunit/test_suite.rb:16:in `run'",
      "./samples/../lib/gunit/test_runner.rb:44:in `run'",
      "./samples/../lib/gunit/test_runner.rb:41:in `each'",
      "./samples/../lib/gunit/test_runner.rb:41:in `run'",
      "samples/foo_sample.rb:177"]
    @fail_response2 = GUnit::FailResponse.new(backtrace)
    assert_equal line_number, @fail_response2.line_number
  end
  
  def test_file_name
    assert_nil @fail_response1.file_name
    
    file_name = 'my_test.rb'
    backtrace = ["./samples/../lib/gunit/assertions.rb:23:in `assert'",
      "./samples/../lib/gunit/assertions.rb:79:in `assert_raises'",
      "samples/#{file_name}:63:in `__bind_1264219445_661068'",
      "./samples/../lib/gunit/verification.rb:19:in `call'",
      "./samples/../lib/gunit/verification.rb:19:in `run'",
      "./samples/../lib/gunit/test_case.rb:108:in `test_not_exceptional'",
      "./samples/../lib/gunit/test_case.rb:38:in `send'",
      "./samples/../lib/gunit/test_case.rb:38:in `run'",
      "./samples/../lib/gunit/test_suite.rb:21:in `run'",
      "./samples/../lib/gunit/test_suite.rb:16:in `each'",
      "./samples/../lib/gunit/test_suite.rb:16:in `run'",
      "./samples/../lib/gunit/test_runner.rb:44:in `run'",
      "./samples/../lib/gunit/test_runner.rb:41:in `each'",
      "./samples/../lib/gunit/test_runner.rb:41:in `run'",
      "samples/foo_sample.rb:177"]
    @fail_response2 = GUnit::FailResponse.new(backtrace)
    assert_equal file_name, @fail_response2.file_name
  end
  
  
end
