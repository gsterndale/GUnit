require File.join(File.dirname(__FILE__), '..', 'test_helper')

# class MyClassTest < GUnit::TestCase
#   setup "Some fixtures should be created here"
#   
#   context "An instance of MyClass"
#     setup "my fixture with attributes" do
#       ...
#     end
#   end
# end

class GUnit::SetupTest < Test::Unit::TestCase
  
  def setup
    @setup1 = GUnit::Setup.new
  end
  
  def test_it_is_a_setup
    assert @setup1.is_a?(GUnit::Setup)
  end
  
  def test_has_default_message
    assert_not_nil @setup1.message
  end
  
  def test_message_setter
    message = "Set something up"
    @setup1.message = message
    assert_equal message, @setup1.message
  end
  
  # Setup.new('my fixtures')
  def test_initialize_with_one_arg
    message = 'my fixtures'
    @setup2 = GUnit::Setup.new(message)
    assert @setup2.message === message
  end
  
  # Setup.new('my fixtures'){ @foo = "bar" }
  def test_initialize_with_one_arg_and_block
    message = 'my fixtures'
    task    = (@foo = "bar")
    @setup2 = GUnit::Setup.new(message) { (@foo = "bar") }
    assert message === @setup2.message
    assert task === @setup2.task.call
  end
  
  def test_run_with_task_called_returns_true
    @setup1.task = Proc.new { true }
    response = @setup1.run
    assert response === true
  end
  
  def test_run_with_task_called_returns_false
    @setup1.task = Proc.new { false }
    response = @setup1.run
    assert response === true
  end
  
  def test_run_with_task_is_false
    @setup1.task = false
    response = @setup1.run
    assert response === true
  end
  
  def test_run_with_task_is_nil
    @setup1.task = nil
    response = @setup1.run
    assert response === true
  end
  
  def test_run_with_assertion_failure_exception
    @setup1.task = lambda { raise GUnit::AssertionFailure }
    response = @setup1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
  end
  
  def test_run_with_random_exception
    @setup1.task = lambda { raise 'Boom' }
    response = @setup1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
  end
  
  def test_run_with_binding
    obj = Object.new
    obj.instance_variable_set("@foo", "bar")
    @setup1.task = Proc.new { instance_variable_set("@foo", "zip") }
    @setup1.run
    assert_equal "bar", obj.instance_variable_get("@foo")
    @setup1.run(obj)
    assert_equal "zip", obj.instance_variable_get("@foo")
  end
  
end
