require 'test_helper'

class MyClass
end

class MyClassTest < GUnit::TestCase
  
  # context "An instance of MyClass"
  #   # One setup per context
  #   setup do
  #     @my_class = MyClass.new
  #   end
  #   
  #   # One exercise per context
  #   exercise do
  #   end
  # 
  #   # One teardown per context
  #   teardown do
  #     @my_class.delete
  #   end
  #   
  #   # Many verifies per context
  #   verify "true is true" do
  #     assert true
  #   end
  #   
  #   # Many verifies per context
  #   verify "these verifications pass without reloading setup, exercise or teardown" do
  #     
  #     assert { true }
  #     assert "true is true" { true }
  #     assert true
  #     assert_equal true, true
  #     assert_equal true, true, "true is true"
  #     assert_equal true, true, "true is true" {|a,b| a === b }
  #     
  #     assert_is_a @my_class, MyClass
  #   
  #     assert_nil nil
  #   
  #     assert_nil nil, "nil is nil"
  #   
  #     assert_raise do
  #       raise RuntimeError
  #     end
  #   
  #     assert_raise RuntimeError do
  #       raise RuntimeError
  #     end
  #   
  #     assert_raise RuntimeError, "blow up" do
  #       raise RuntimeError
  #     end
  #   end
  #   
  #   # many nested contexts per context
  #   context "doing something" do
  #     exercise do
  #       @my_class.do_something
  #     end
  #     verify "something changed" do
  #       assert_change @my_class.something, :by => -1
  #       assert_change "@my_class.something_else", :from => true, :to => false
  #       assert_change "@my_class.third_thing" {|before, after| before < after }
  #     end
  #   end
  # end
  
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
  
  def test_verify_creates_class_method
    method_count = MyClassTest.public_methods.length
    args = true
    dynamic_method_name = MyClassTest.verify(args)
    assert_equal method_count + 1, MyClassTest.public_methods.length
    assert dynamic_method_name.to_s =~ /\d\z/
    assert MyClassTest.respond_to?(dynamic_method_name)
    verification = GUnit::Verification.new
    pass = GUnit::PassResponse.new
    verification.expects(:run).returns(pass)
    GUnit::Verification.expects(:new).with(args).returns(verification)
    assert_equal pass, MyClassTest.send(dynamic_method_name)
  end
  
  def test_verify_with_block_creates_class_method
    method_count = MyClassTest.public_methods.length
    args = "The truth"
    blk  = Proc.new{ true }
    dynamic_method_name = MyClassTest.verify(args)
    assert_equal method_count + 1, MyClassTest.public_methods.length
    assert dynamic_method_name.to_s =~ /\d\z/
    assert MyClassTest.respond_to?(dynamic_method_name)
    verification = GUnit::Verification.new
    pass = GUnit::PassResponse.new
    verification.expects(:run).returns(pass)
# TODO how to set expectation that blk is passed to new() ???
    GUnit::Verification.expects(:new).with(args).returns(verification)
    assert_equal pass, MyClassTest.send(dynamic_method_name)
  end
  
  def test_suite_returns_test_suite
    assert MyClassTest.suite.is_a?(GUnit::TestSuite)
  end
  
  def test_assert_true
    response = @my_test_case.assert(true)
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::PassResponse)
  end
  
  def test_assert_false
    response = @my_test_case.assert(false)
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
  end
  
  def test_assert_with_exception_raised
    boom = lambda{ raise StandardError }
    # assert_raise(StandardError) { boom.call }
    response = @my_test_case.assert( boom )
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
  end
  
end
