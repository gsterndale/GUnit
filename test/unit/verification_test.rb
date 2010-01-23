require File.join(File.dirname(__FILE__), '..', 'test_helper')

# class MyClassTest < GUnit::TestCase
#   verify_is_a @my_class, MyClass
#   
#   context "An instance of MyClass"
#     
#     verify "true is true" do
#       verify true != nil
#       verify true == true
#       verify true === true
#     end
#   end
# end

class GUnit::VerificationTest < Test::Unit::TestCase
  
  def setup
    @verification1 = GUnit::Verification.new
  end
  
  def test_it_is_a_verification
    assert @verification1.is_a?(GUnit::Verification)
  end
  
  def test_has_default_message
    assert_not_nil @verification1.message
  end
  
  def test_message_setter
    message = "Whoops"
    @verification1.message = message
    assert_equal message, @verification1.message
  end
  
  # Verification.new('one is less than two')
  def test_initialize_with_one_arg
    message = 'one is less than two'
    @verification2 = GUnit::Verification.new(message)
    assert @verification2.message === message
  end
  
  # Verification.new('one is less than two'){ assert 1<2 }
  def test_initialize_with_one_arg_and_block
    message = 'one is less than two'
    task    = 'my task'
    @verification2 = GUnit::Verification.new(message) { task }
    assert message === @verification2.message
    assert task === @verification2.task.call
  end
  
  def test_run_with_task_called_returns_true
    @verification1.task = lambda { true }
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::PassResponse)
  end
  
  def test_run_with_task_called_returns_false
    @verification1.task = lambda { false }
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::PassResponse)
  end
  
  def test_run_with_task_is_false
    @verification1.task = false
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ToDoResponse)
  end
  
  def test_run_with_task_is_nil
    message = 'Not dun yet'
    stack = ["./samples/../lib/gunit/verification.rb:25:in `test_not_dun_yet'",
             "./samples/../lib/gunit/verification.rb:25:in `test_not_dun_yet'",
             "./samples/../lib/gunit/test_case.rb:38:in `send'",
             "./samples/../lib/gunit/test_case.rb:38:in `run'",
             "./samples/../lib/gunit/test_suite.rb:21:in `run'",
             "./samples/../lib/gunit/test_suite.rb:16:in `each'",
             "./samples/../lib/gunit/test_suite.rb:16:in `run'",
             "./samples/../lib/gunit/test_runner.rb:44:in `run'",
             "./samples/../lib/gunit/test_runner.rb:41:in `each'",
             "./samples/../lib/gunit/test_runner.rb:41:in `run'",
             "samples/foo_sample.rb:177"]
    to_do_response = GUnit::ToDoResponse.new(message, stack)
    @verification1.message = message
    @verification1.task = nil
    GUnit::ToDoResponse.expects(:new).with{|m,b| m == message && b.is_a?(Array) }.once.returns(to_do_response)
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ToDoResponse)
    assert_equal message, response.message
    assert_equal stack, response.backtrace
  end
  
  def test_run_with_binding
    obj = Object.new
    obj.instance_variable_set("@foo", "bar")
    @verification1.task = Proc.new { instance_variable_set("@foo", "zip") }
    @verification1.run
    assert_equal "bar", obj.instance_variable_get("@foo")
    @verification1.run(obj)
    assert_equal "zip", obj.instance_variable_get("@foo")
  end
  
  def test_run_with_assertion_failure_exception
    message = "boooooooom"
    backtrace = ['ohnoes']
    assertion_failure = GUnit::AssertionFailure.new(message)
    assertion_failure.expects(:backtrace).at_least_once.returns(backtrace)
    @verification1.task = lambda { raise assertion_failure }
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
    assert_equal message, response.message
    assert_equal backtrace, response.backtrace
  end
  
  def test_run_with_random_exception
    message = "boooooooom"
    backtrace = ['ohnoes']
    exception = Exception.new(message)
    exception.set_backtrace(backtrace)
    @verification1.task = lambda { raise exception }
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
    assert_equal message, response.message
    assert_equal backtrace, response.backtrace
  end
    
end
