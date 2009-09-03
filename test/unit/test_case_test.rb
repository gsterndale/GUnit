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
  
  def test_verify_creates_instance_method
    method_count = MyClassTest.instance_methods.length
    args = "TODO add some feature"
    dynamic_method_name = MyClassTest.verify(args)
    assert_equal method_count + 1, MyClassTest.instance_methods.length
    assert dynamic_method_name.to_s =~ /\d\z/
    assert MyClassTest.instance_methods.include?(dynamic_method_name.to_s)
    verification = GUnit::Verification.new
    todo = GUnit::ToDoResponse.new
    verification.expects(:run).returns(todo)
    GUnit::Verification.expects(:new).with(args).returns(verification)
    assert_equal todo, MyClassTest.new.send(dynamic_method_name)
  end
  
  def test_verify_with_block_creates_instance_method
    method_count = MyClassTest.instance_methods.length
    args = "The truth"
    blk  = Proc.new{ true }
    dynamic_method_name = MyClassTest.verify(args)
    assert_equal method_count + 1, MyClassTest.instance_methods.length
    assert dynamic_method_name.to_s =~ /\d\z/
    assert MyClassTest.new.respond_to?(dynamic_method_name)
    verification = GUnit::Verification.new
    pass = GUnit::PassResponse.new
    verification.expects(:run).returns(pass)
# TODO how to set expectation that blk is passed to new() ???
    GUnit::Verification.expects(:new).with(args).returns(verification)
    assert_equal pass, MyClassTest.new.send(dynamic_method_name)
  end
  
  def test_test_methods
    assert MyClassTest.test_methods.include?(:test_one)
    assert MyClassTest.test_methods.include?(:test_two)
    assert ! MyClassTest.test_methods.include?(:not_a_test_method)
    assert MyClassTest.test_methods.length == 2
  end
  
  def test_suite_returns_test_suite_with_test_cases
    test_suite = MyClassTest.suite
    assert test_suite.is_a?(GUnit::TestSuite)
    assert test_suite.tests.length == 2
    assert test_suite.tests.find{|t| t.method_name == :test_one }
    assert test_suite.tests.find{|t| t.method_name == :test_two }
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
  
end
