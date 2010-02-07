require File.join(File.dirname(__FILE__), '..', 'test_helper')

class MyClass
end

class MyClassTest < GUnit::TestCase
  def test_one
  end
  def test_two
  end
  def not_a_test_method
  end
end

class GUnit::TestCaseTest < Test::Unit::TestCase
  
  def setup
    @my_test_case = MyClassTest.new
  end
  
  def test_it_is_a_test_case
    assert @my_test_case.is_a?(GUnit::TestCase)
  end

  def test_subclasses_class_attr
    assert ! GUnit::TestCase.subclasses.empty?
    assert GUnit::TestCase.subclasses.include?(MyClassTest)
  end

  def test_autorun_class_attr
    assert GUnit::TestCase.autorun? === false # set to false in test_helper.rb
    GUnit::TestCase.autorun = true
    assert GUnit::TestCase.autorun?
    GUnit::TestRunner.expects(:instance).times(1).returns(mock(:tests => [], :run! => true))
    MyClassTest.autorun
    GUnit::TestCase.autorun = false
    GUnit::TestRunner.expects(:instance).times(0)
    MyClassTest.autorun
  end

  def test_method_name_setter_getter
    method_name = "my_method"
    assert_not_equal method_name, @my_test_case.method_name
    @my_test_case.method_name = method_name
    assert_equal method_name, @my_test_case.method_name
  end
  
  def test_constructor
    method_name = "my_method"
    @my_test_case1 = MyClassTest.new()
    assert_not_equal method_name, @my_test_case1.method_name
    @my_test_case1 = MyClassTest.new(method_name)
    assert_equal method_name, @my_test_case1.method_name
  end
  
  def test_run_calls_method_name
    method_name = "my_method"
    @my_test_case1 = MyClassTest.new(method_name)
    @my_test_case1.expects(method_name.to_sym)
    @my_test_case1.run
  end
  
  def test_run_returns_method_result
    method_name = "my_method"
    result      = "my result"
    @my_test_case1 = MyClassTest.new(method_name)
    @my_test_case1.expects(method_name.to_sym).returns(result)
    assert_equal result, @my_test_case1.run
  end
  
  def test_message_to_test_method_name
    msg = "Check for expected outcome"
    method_name = MyClassTest.message_to_test_method_name(msg)
    assert method_name.is_a?(Symbol)
    assert method_name.to_s =~ /#{MyClassTest::TEST_METHOD_PREFIX}_check_for_expected_outcome/
  end
  
  def test_verify_creates_instance_method
    method_count = MyClassTest.instance_methods.length
    args = "TODO add some feature"
    dynamic_method_name = MyClassTest.verify(args)
    assert_equal method_count + 1, MyClassTest.instance_methods.length
    assert dynamic_method_name.to_s =~ /#{MyClassTest::TEST_METHOD_PREFIX}/
    assert MyClassTest.instance_methods.include?(dynamic_method_name.to_s)
    message = 'The truth'
    verification = mock(:message => message, :run => true)
    GUnit::Verification.expects(:new).with(args).returns(verification)
    response = MyClassTest.new.send(dynamic_method_name)
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::PassResponse)
    assert_equal message, response.message
  end
  
  def test_verify_with_block_creates_instance_method
    method_count = MyClassTest.instance_methods.length
    args = "The truth"
    blk  = Proc.new{ true }
    dynamic_method_name = MyClassTest.verify(args)
    assert_equal method_count + 1, MyClassTest.instance_methods.length
    assert dynamic_method_name.to_s =~ /#{MyClassTest::TEST_METHOD_PREFIX}/
    assert MyClassTest.new.respond_to?(dynamic_method_name)
    message = 'The truth'
    verification = mock(:message => message, :run => true)
# TODO how to set expectation that blk is passed to new() ???
    GUnit::Verification.expects(:new).returns(verification)
    response = MyClassTest.new.send(dynamic_method_name)
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::PassResponse)
    assert_equal message, response.message
  end
  
  def test_run_runs_setups
    MyClassTest.setup { @foo = "bar" }
    method_name = "test_one"
    @my_test_case1 = MyClassTest.new(method_name)
    @my_test_case1.run
    assert_equal "bar", @my_test_case1.instance_variable_get("@foo")
  end
  
  def test_run_runs_exercise
    MyClassTest.setup { @foo = "abc" }
    MyClassTest.exercise { @foo.replace "bar" }
    method_name = "test_one"
    @my_test_case1 = MyClassTest.new(method_name)
    @my_test_case1.run
    assert_equal "bar", @my_test_case1.instance_variable_get("@foo")
  end
  
  def test_run_runs_teardowns
    @my_test_case2 = MyClassTest.new
    MyClassTest.setup { @foo = "bar" }
    MyClassTest.teardown { @foo = "zip" }
    method_name = "test_one"
    @my_test_case2 = MyClassTest.new(method_name)
    @my_test_case2.run
    assert_equal "zip", @my_test_case2.instance_variable_get("@foo")
  end
  
  def test_run_runs_teardowns_in_reverse_order
    @my_test_case3 = MyClassTest.new
    MyClassTest.setup { @foo = "bar" }
    MyClassTest.teardown { @foo = "zip" }
    MyClassTest.teardown { @foo = "zap" }
    method_name = "test_one"
    @my_test_case3 = MyClassTest.new(method_name)
    @my_test_case3.run
    assert_equal "zip", @my_test_case3.instance_variable_get("@foo")
  end

  def test_run_with_test_method_raising_assertion_failure
    exception_message = 'Whoops'
    exception = GUnit::AssertionFailure.new(exception_message)
    verify_message = "The truth"
    verification = mock
    verification.expects(:run).raises(exception)
    dynamic_method_name = MyClassTest.verify(verify_message)
    GUnit::Verification.expects(:new).with(verify_message).returns(verification)
    @my_test_case4 = MyClassTest.new(dynamic_method_name)
    response = @my_test_case4.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
    assert_equal exception_message, response.message
    assert_equal @my_test_case4, response.test_case
  end

  def test_run_with_test_method_raising_nothing_to_do_exception
    exception_message = 'Nothin here'
    exception = GUnit::NothingToDo.new(exception_message)
    verify_message = "The truth"
    verification = mock
    verification.expects(:run).raises(exception)
    dynamic_method_name = MyClassTest.verify(verify_message)
    GUnit::Verification.expects(:new).with(verify_message).returns(verification)
    @my_test_case5 = MyClassTest.new(dynamic_method_name)
    response = @my_test_case5.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ToDoResponse)
    assert_equal exception_message, response.message
  end

  def test_run_with_test_method_raising_random_exception
    exception_message = 'Whoops'
    exception = ::StandardError.new(exception_message)
    verify_message = "The truth"
    verification = mock
    verification.expects(:run).raises(exception)
    dynamic_method_name = MyClassTest.verify(verify_message)
    GUnit::Verification.expects(:new).with(verify_message).returns(verification)
    @my_test_case5 = MyClassTest.new(dynamic_method_name)
    response = @my_test_case5.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
    assert_equal exception_message, response.message
  end

  def test_run_with_test_method_raising_string
    exception = 'Whoops'
    verify_message = "The truth"
    verification = mock
    verification.expects(:run).raises(exception)
    dynamic_method_name = MyClassTest.verify(verify_message)
    GUnit::Verification.expects(:new).with(verify_message).returns(verification)
    @my_test_case5 = MyClassTest.new(dynamic_method_name)
    response = @my_test_case5.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
    assert_equal exception, response.message
  end
  
  def test_test_methods
    assert MyClassTest.test_methods.include?(:test_one)
    assert MyClassTest.test_methods.include?(:test_two)
    assert ! MyClassTest.test_methods.include?(:not_a_test_method)
  end
  
  def test_suite_returns_test_suite_with_test_cases
    test_suite = MyClassTest.suite
    assert test_suite.is_a?(GUnit::TestSuite)
    assert test_suite.tests.find{|t| t.method_name == :test_one }
    assert test_suite.tests.find{|t| t.method_name == :test_two }
    assert_nil test_suite.tests.find{|t| t.method_name == :not_a_test_method}
  end
  
  def test_assert_true
    response = @my_test_case.assert(1==1)
    assert response === true
  end
  
  def test_assert_false
    assert_raise GUnit::AssertionFailure do
      @my_test_case.assert(1==0)
    end
  end
  
  def test_assert_with_exception_raised
    boom = lambda{ raise RuntimeError }
    assert_raise RuntimeError do
      @my_test_case.assert( boom )
    end
  end
  
  def test_verify_inside_context_defines_test_method_with_context
    context_msg   = "In some context"
    verify_msg    = "This should be the case A"
    MyClassTest.context(context_msg) do
      verify(verify_msg) { true }
    end
    method_name = MyClassTest.message_to_test_method_name(verify_msg)
    assert MyClassTest.method_defined?(method_name)
    context = MyClassTest.context_for_method(method_name)
    assert_not_nil context
    assert_equal context_msg, context.message
  end
  
  def test_setup_and_teardown_inside_context_creates_context_with_setup_and_teardown
    context_msg   = "In some context"
    setup_msg     = "Given this"
    exercise_msg  = "Doing this"
    teardown_msg  = "Housekeeping"
    verify_msg    = "This should be the case B"
    MyClassTest.context(context_msg) do
      setup(setup_msg) { @foo = "abc" }
      exercise(exercise_msg) { @foo.replace "xyz" }
      teardown(teardown_msg) { @foo = "def" }
      verify(verify_msg) { true }
    end
    method_name = MyClassTest.message_to_test_method_name(verify_msg)
    context = MyClassTest.context_for_method(method_name)
    assert_equal setup_msg, context.setups.last.message
    assert_equal exercise_msg, context.exercise.message
    assert_equal teardown_msg, context.teardowns.last.message
  end
  
  def test_context_creates_context_with_parent
    context_msg   = "In some context"
    verify_msg    = "This should be the case C"
    MyClassTest.context(context_msg) do
      verify(verify_msg) { true }
    end
    method_name = MyClassTest.message_to_test_method_name(verify_msg)
    context = MyClassTest.context_for_method(method_name)
    assert_not_nil context.parent
    assert context.parent.is_a?(GUnit::Context)
  end
  
  def test_test_method_outside_context_block_has_context
    method_name = 'test_one'
    context = MyClassTest.context_for_method(method_name)
    assert_not_nil context
    assert context.is_a?(GUnit::Context)
  end
  
  def test_run_runs_contexts_setups
    setup = GUnit::Setup.new { @foo = @foo.nil? ? 1 : @foo+1 }
    pops = GUnit::Context.new
    pops.setups = [setup, setup]
    parent = GUnit::Context.new
    parent.setups = [setup, setup]
    parent.parent = pops
    context1 = GUnit::Context.new
    context1.setups = [setup, setup]
    context1.parent = parent
    method_name = "test_one"
    @my_test_case1 = MyClassTest.new(method_name)
    @my_test_case1.stubs(:context).returns(context1)
    @my_test_case1.run
    assert_equal 6, @my_test_case1.instance_variable_get("@foo")
  end
  
  def test_run_runs_context_exercise_only
    exercise = GUnit::Exercise.new { @foo = @foo.nil? ? 1 : @foo+1 }
    pops = GUnit::Context.new
    pops.exercise = exercise
    parent = GUnit::Context.new
    parent.exercise = exercise
    parent.parent = pops
    context1 = GUnit::Context.new
    context1.exercise = exercise
    context1.parent = parent
    method_name = "test_one"
    @my_test_case1 = MyClassTest.new(method_name)
    @my_test_case1.stubs(:context).returns(context1)
    @my_test_case1.run
    assert_equal 1, @my_test_case1.instance_variable_get("@foo")
  end
  
  def test_run_runs_contexts_teardowns
    teardown = GUnit::Teardown.new { @foo = @foo.nil? ? 1 : @foo+1 }
    pops = GUnit::Context.new
    pops.teardowns = [teardown, teardown]
    parent = GUnit::Context.new
    parent.teardowns = [teardown, teardown]
    parent.parent = pops
    context1 = GUnit::Context.new
    context1.teardowns = [teardown, teardown]
    context1.parent = parent
    method_name = "test_one"
    @my_test_case1 = MyClassTest.new(method_name)
    @my_test_case1.stubs(:context).returns(context1)
    @my_test_case1.run
    assert_equal 6, @my_test_case1.instance_variable_get("@foo")
  end
  
  def test_run_runs_contexts_teardowns_in_reverse_order
    teardown = GUnit::Teardown.new { @foo = @foo.nil? ? 1 : @foo+1 }
    last_teardown = GUnit::Teardown.new { @foo = -1 }
    pops = GUnit::Context.new
    pops.teardowns = [last_teardown, teardown]
    parent = GUnit::Context.new
    parent.teardowns = [teardown, teardown]
    parent.parent = pops
    context1 = GUnit::Context.new
    context1.teardowns = [teardown, teardown]
    context1.parent = parent
    method_name = "test_one"
    @my_test_case1 = MyClassTest.new(method_name)
    @my_test_case1.stubs(:context).returns(context1)
    @my_test_case1.run
    assert_equal -1, @my_test_case1.instance_variable_get("@foo")
  end
end
