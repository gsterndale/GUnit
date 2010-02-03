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
    assert response === true
  end
  
  def test_run_with_task_called_returns_false
    @verification1.task = lambda { false }
    response = @verification1.run
    assert response === false
  end
  
  def test_run_with_task_is_false
    @verification1.task = false
    assert_raise GUnit::NothingToDo do
      @verification1.run
    end
  end
  
  def test_run_with_task_is_nil
    message = 'Not dun yet'
    @verification1.message = message
    @verification1.task = nil
    assert_raise GUnit::NothingToDo do
      @verification1.run
    end
    begin
      @verification1.run
    rescue GUnit::NothingToDo => exception
      assert_equal message, exception.message     
    end
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

end
