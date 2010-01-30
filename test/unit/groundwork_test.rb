require File.join(File.dirname(__FILE__), '..', 'test_helper')

# class MyClassTest < GUnit::TestCase
#   groundwork "Some fixtures should be created here"
#   
#   context "An instance of MyClass"
#     groundwork "renamed" do
#       @foo.rename("the foo")
#     end
#   end
# end

class GUnit::GroundworkTest < Test::Unit::TestCase
  
  def setup
    @groundwork1 = GUnit::Groundwork.new
  end
  
  def test_it_is_a_groundwork
    assert @groundwork1.is_a?(GUnit::Groundwork)
  end
  
  def test_has_default_message
    assert_not_nil @groundwork1.message
    assert_equal 'Groundwork', @groundwork1.message
  end
  
  def test_message_setter
    message = "Groundwork some code"
    @groundwork1.message = message
    assert_equal message, @groundwork1.message
  end
  
  # Groundwork.new('some feature')
  def test_initialize_with_one_arg
    message = 'some feature'
    @groundwork2 = GUnit::Groundwork.new(message)
    assert @groundwork2.message === message
  end
  
  # Groundwork.new('some feature'){ @foo = "bar" }
  def test_initialize_with_one_arg_and_block
    message = 'some feature'
    task    = (@foo = "bar")
    @groundwork2 = GUnit::Groundwork.new(message) { (@foo = "bar") }
    assert message === @groundwork2.message
    assert task === @groundwork2.task.call
  end
  
  def test_run_with_task_called_returns_true
    @groundwork1.task = Proc.new { true }
    response = @groundwork1.run
    assert response === true
  end
  
  def test_run_with_task_called_returns_false
    @groundwork1.task = Proc.new { false }
    response = @groundwork1.run
    assert response === true
  end
  
  def test_run_with_task_is_false
    @groundwork1.task = false
    response = @groundwork1.run
    assert response === true
  end
  
  def test_run_with_task_is_nil
    @groundwork1.task = nil
    response = @groundwork1.run
    assert response === true
  end
  
  def test_run_with_assertion_failure_exception
    @groundwork1.task = lambda { raise GUnit::AssertionFailure }
    response = @groundwork1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
  end
  
  def test_run_with_random_exception
    @groundwork1.task = lambda { raise 'Boom' }
    response = @groundwork1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
  end
  
  def test_run_with_binding
    obj = Object.new
    obj.instance_variable_set("@foo", "bar")
    @groundwork1.task = Proc.new { instance_variable_set("@foo", "zip") }
    @groundwork1.run
    assert_equal "bar", obj.instance_variable_get("@foo")
    @groundwork1.run(obj)
    assert_equal "zip", obj.instance_variable_get("@foo")
  end
  
end
