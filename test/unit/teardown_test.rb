require File.join(File.dirname(__FILE__), '..', 'test_helper')

# class MyClassTest < GUnit::TestCase
#   teardown "Delete some fixtures here"
#   
#   context "An instance of MyClass"
#     teardown "delete my fixture" do
#       ...
#     end
#   end
# end

class GUnit::TeardownTest < Test::Unit::TestCase
  
  def setup
    @teardown1 = GUnit::Teardown.new
  end
  
  def test_it_is_a_teardown
    assert @teardown1.is_a?(GUnit::Teardown)
  end
  
  def test_has_default_message
    assert_not_nil @teardown1.message
  end
  
  def test_message_setter
    message = "Set something up"
    @teardown1.message = message
    assert_equal message, @teardown1.message
  end
  
  # Teardown.new('my fixtures')
  def test_initialize_with_one_arg
    message = 'my fixtures'
    @teardown2 = GUnit::Teardown.new(message)
    assert @teardown2.message === message
  end
  
  # Teardown.new('my fixtures'){ @foo = "bar" }
  def test_initialize_with_one_arg_and_block
    message = 'my fixtures'
    task    = (@foo = "bar")
    @teardown2 = GUnit::Teardown.new(message) { (@foo = "bar") }
    assert message === @teardown2.message
    assert task === @teardown2.task.call
  end
  
  def test_run_with_task_called_returns_true
    @teardown1.task = Proc.new { true }
    response = @teardown1.run
    assert response === true
  end
  
  def test_run_with_task_called_returns_false
    @teardown1.task = Proc.new { false }
    response = @teardown1.run
    assert response === true
  end
  
  def test_run_with_task_is_false
    @teardown1.task = false
    response = @teardown1.run
    assert response === true
  end
  
  def test_run_with_task_is_nil
    @teardown1.task = nil
    response = @teardown1.run
    assert response === true
  end
  
  def test_run_with_assertion_failure_exception
    @teardown1.task = lambda { raise GUnit::AssertionFailure }
    response = @teardown1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
  end
  
  def test_run_with_random_exception
    @teardown1.task = lambda { raise 'Boom' }
    response = @teardown1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
  end
  
  def test_run_with_binding
    obj = Object.new
    obj.instance_variable_set("@foo", "bar")
    @teardown1.task = Proc.new { instance_variable_set("@foo", "zip") }
    @teardown1.run
    assert_equal "bar", obj.instance_variable_get("@foo")
    @teardown1.run(obj)
    assert_equal "zip", obj.instance_variable_get("@foo")
  end
  
end
