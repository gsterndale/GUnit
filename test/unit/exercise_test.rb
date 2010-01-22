require File.join(File.dirname(__FILE__), '..', 'test_helper')

# class MyClassTest < GUnit::TestCase
#   exercise "Some fixtures should be created here"
#   
#   context "An instance of MyClass"
#     setup "a Foo with a name" do
#       @foo = Foo.new("a foo")
#     end
#     exercise "renamed" do
#       @foo.rename("the foo")
#     end
#   end
# end

class GUnit::ExerciseTest < Test::Unit::TestCase
  
  def setup
    @exercise1 = GUnit::Exercise.new
  end
  
  def test_it_is_a_exercise
    assert @exercise1.is_a?(GUnit::Exercise)
  end
  
  def test_has_default_message
    assert_not_nil @exercise1.message
  end
  
  def test_message_setter
    message = "Exercise some code"
    @exercise1.message = message
    assert_equal message, @exercise1.message
  end
  
  # Exercise.new('some feature')
  def test_initialize_with_one_arg
    message = 'some feature'
    @exercise2 = GUnit::Exercise.new(message)
    assert @exercise2.message === message
  end
  
  # Exercise.new('some feature'){ @foo = "bar" }
  def test_initialize_with_one_arg_and_block
    message = 'some feature'
    task    = (@foo = "bar")
    @exercise2 = GUnit::Exercise.new(message) { (@foo = "bar") }
    assert message === @exercise2.message
    assert task === @exercise2.task.call
  end
  
  def test_run_with_task_called_returns_true
    @exercise1.task = Proc.new { true }
    response = @exercise1.run
    assert response === true
  end
  
  def test_run_with_task_called_returns_false
    @exercise1.task = Proc.new { false }
    response = @exercise1.run
    assert response === true
  end
  
  def test_run_with_task_is_false
    @exercise1.task = false
    response = @exercise1.run
    assert response === true
  end
  
  def test_run_with_task_is_nil
    @exercise1.task = nil
    response = @exercise1.run
    assert response === true
  end
  
  def test_run_with_assertion_failure_exception
    @exercise1.task = lambda { raise GUnit::AssertionFailure }
    response = @exercise1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
  end
  
  def test_run_with_random_exception
    @exercise1.task = lambda { raise 'Boom' }
    response = @exercise1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
  end
  
  def test_run_with_binding
    obj = Object.new
    obj.instance_variable_set("@foo", "bar")
    @exercise1.task = Proc.new { instance_variable_set("@foo", "zip") }
    @exercise1.run
    assert_equal "bar", obj.instance_variable_get("@foo")
    @exercise1.run(obj)
    assert_equal "zip", obj.instance_variable_get("@foo")
  end
  
end
