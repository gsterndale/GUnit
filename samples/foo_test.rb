require File.dirname(__FILE__) + '/../lib/gunit'

class Foo
end

class FooTest < GUnit::TestCase
  
  # context "An instance of Foo"
  #   # One setup per context
  #   setup do
  #     @foo = Foo.new
  #   end
  #   
  #   # One exercise per context
  #   exercise do
  #     @foo.do_something
  #   end
  # 
  #   # One teardown per context
  #   teardown do
  #     @foo.delete
  #   end
  #   
  #   # Many verifies per context
  #   verify "true is true" do
  #     assert true
  #   end
  #   
  #   # Many verifies per context, some share fixtures
  #   # setup, exercise and teardown will only be run once for all methods in this context with the second param == true
  #   verify "one and one is two", true do
  #     assert 1+1 == 2
  #   end
  #   
  #   # Many verifies per context, some share fixtures
  #   # setup, exercise and teardown will only be run once for all methods in this context with the second param == true
  #   verify "one is more than none", true do
  #     assert 1 > 0
  #   end
  # 
  #   # Many verifies per context
  #   verify "the truth" do
  #     assert { true }
  #     assert "true is true" { true }
  #     assert true
  #     assert_equal true, true
  #     assert_equal true, true, "true is true"
  #     assert_equal true, true, "true is true" {|a,b| a === b }
  #     
  #     assert_is_a @foo, Foo
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
  #   context "doing something else" do
  #     exercise do
  #       @foo.do_something_else
  #     end
  #     verify "something changed" do
  #       assert_change @foo.something, :by => -1
  #       assert_change "@foo.something_else", :from => true, :to => false
  #       assert_change "@foo.third_thing" {|before, after| before < after }
  #     end
  #   end
  # end
  
end