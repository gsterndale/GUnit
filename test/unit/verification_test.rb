require 'test_helper'

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
    @verification1.task = nil
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ToDoResponse)
  end
  
  def test_run_with_assertion_failure_exception
    @verification1.task = lambda { raise GUnit::AssertionFailure }
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
  end
  
  def test_run_with_random_exception
    @verification1.task = lambda { raise 'Boom' }
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
  end
    
end
