require 'test_helper'

class MyClass
end

class MyClassTest < GUnit::TestCase
    
    # verify_is_a @my_class, MyClass
    # 
    # context "An instance of MyClass"
    #   
    #   setup do
    #     @my_class = MyClass.new
    #   end
    # 
    #   exercise do
    #   end
    # 
    #   verify "true is true" do
    #     true
    #   end
    #   
    #   verify "these verifications pass without reloading setup, exercise or teardown" do
    #     
    #     verify { true }
    #     verify "true is true" { true }
    #     verify true
    #     verify_equal true, true
    #     verify_equal true, true, "true is true"
    #     verify_equal true, true, "true is true" {|a,b| a === b }
    #     
    #   end
    #   
    #   verify_nil nil
    #   
    #   verify_nil nil, "nil is nil"
    #   
    #   verify_raise do
    #     raise RuntimeError
    #   end
    #   
    #   verify_raise RuntimeError do
    #     raise RuntimeError
    #   end
    #   
    #   verify_raise RuntimeError, "blow up" do
    #     raise RuntimeError
    #   end
    #   
    #   teardown do
    #     @my_class.delete
    #   end
    #   
    #   context "doing something" do
    #     exercise do
    #       @my_class.do_something
    #     end
    #     verify_change @my_class.something, :by => -1
    #     verify_change "@my_class.something_else", :from => true, :to => false
    #     verify_change "@my_class.third_thing" {|before, after| before < after }
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
  
  
end
