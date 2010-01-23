require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::TestResponseTest < Test::Unit::TestCase
  
  def setup
    @test_response1 = GUnit::TestResponse.new
  end
  
  def test_it_is_a_test_response
    assert @test_response1.is_a?(GUnit::TestResponse)
  end
  
  def test_has_default_message
    assert_not_nil @test_response1.message
  end
  
  def test_has_default_backtrace
    assert_not_nil @test_response1.backtrace
    assert_equal [], @test_response1.backtrace
  end
  
  def test_message_setter
    message = "Whoops."
    @test_response1.message = message
    assert_equal message, @test_response1.message
  end
  
  def test_backtrace_setter
    backtrace = ['a', 'b', 'c']
    @test_response1.backtrace = backtrace
    assert_equal backtrace, @test_response1.backtrace
  end
  
  # TestResponse.new('my fixtures')
  def test_initialize_with_string
    message = 'Uhohs'
    @test_response2 = GUnit::TestResponse.new(message)
    assert @test_response2.message === message
  end
  
  def test_initialize_with_array
    backtrace = ['a', 'b', 'c']
    @test_response2 = GUnit::TestResponse.new(backtrace)
    assert_equal backtrace, @test_response2.backtrace
  end
  
  def test_initialize_with_string_and_array
    message = 'Uhohs'
    backtrace = ['a', 'b', 'c']
    @test_response2 = GUnit::TestResponse.new(message, backtrace)
    assert_equal backtrace, @test_response2.backtrace
    assert @test_response2.message === message
  end
  
  def test_line_number
    assert_nil @test_response1.line_number
    
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
    @test_response2 = GUnit::TestResponse.new(backtrace)
    assert_equal line_number, @test_response2.line_number
  end
  
  def test_file_name
    assert_nil @test_response1.file_name
    
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
    @test_response2 = GUnit::TestResponse.new(backtrace)
    assert_equal file_name, @test_response2.file_name
  end
  
  
end
