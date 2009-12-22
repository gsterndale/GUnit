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

class GUnit::ContextTest < Test::Unit::TestCase
  
  def setup
    @context1 = GUnit::Context.new
  end
  
  def test_it_is_a_setup
    assert @context1.is_a?(GUnit::Context)
  end
  
  def test_has_default_message
    assert_not_nil @context1.message
    assert @context1.message.is_a?(String)
  end
  
  def test_message_setter
    message = "Set something up"
    @context1.message = message
    assert_equal message, @context1.message
  end
  
  def test_setups_setter
    setups = [GUnit::Setup.new, GUnit::Setup.new]
    @context1.setups = setups
    assert_equal setups, @context1.setups
  end
  
  def test_teardowns_setter
    teardowns = [GUnit::Teardown.new, GUnit::Teardown.new]
    @context1.teardowns = teardowns
    assert_equal teardowns, @context1.teardowns
  end
  
  def test_parent_setter
    parent = GUnit::Context.new
    @context1.parent = parent
    assert_equal parent, @context1.parent
  end
  
  def test_message_with_parent
    parent = GUnit::Context.new
    parent.message = "Mom"
    message = "Kid"
    @context1.parent = parent
    @context1.message = message
    assert_equal parent.message + ' ' + message, @context1.all_message
  end
  
  def test_setups_with_parent
    parent = GUnit::Context.new
    parent.setups = [GUnit::Setup.new, GUnit::Setup.new]
    setups = [GUnit::Setup.new, GUnit::Setup.new]
    @context1.parent = parent
    @context1.setups = setups
    assert_equal parent.setups  + setups, @context1.all_setups
  end
  
  def test_teardowns_with_parent
    parent = GUnit::Context.new
    parent.teardowns = [GUnit::Teardown.new, GUnit::Teardown.new]
    teardowns = [GUnit::Teardown.new, GUnit::Teardown.new]
    @context1.parent = parent
    @context1.teardowns = teardowns
    assert_equal parent.teardowns  + teardowns, @context1.all_teardowns
  end
  
  # Context.new('my fixtures')
  def test_initialize_with_one_arg
    message = 'my fixtures'
    @setup2 = GUnit::Context.new(message)
    assert @setup2.message === message
  end
  
  # Context.new('my fixtures'){ @foo = "bar" }
  def test_initialize_with_one_arg_and_block
    message = 'my fixtures'
    task    = (@foo = "bar")
    @setup2 = GUnit::Context.new(message) { (@foo = "bar") }
    assert message === @setup2.message
    assert task === @setup2.task.call
  end
  
  def test_run_with_task_called_returns_true
    @context1.task = Proc.new { true }
    response = @context1.run
    assert response === true
  end
  
  def test_run_with_task_called_returns_false
    @context1.task = Proc.new { false }
    response = @context1.run
    assert response === true
  end
  
  def test_run_with_task_is_false
    @context1.task = false
    response = @context1.run
    assert response === true
  end
  
  def test_run_with_task_is_nil
    @context1.task = nil
    response = @context1.run
    assert response === true
  end
  
  def test_run_with_binding
    obj = Object.new
    obj.instance_variable_set("@foo", "bar")
    @context1.task = Proc.new { instance_variable_set("@foo", "zip") }
    @context1.run
    assert_equal "bar", obj.instance_variable_get("@foo")
    @context1.run(obj)
    assert_equal "zip", obj.instance_variable_get("@foo")
  end
  
end
