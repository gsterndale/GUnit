require File.join(File.dirname(__FILE__), '..', 'test_helper')

class Foo
  include GUnit::Assertions
end


class FooTest < Test::Unit::TestCase
  def setup
    @foo1 = Foo.new
  end
  
  def test_assert_no_arg_one_block
    block   = Proc.new { 1==1 }
    result  = @foo1.assert &block
    assert result === true
  end
  
  def test_assert_one_arg_one_block
    message = "my message here"
    block   = Proc.new { 1==1 }
    result  = @foo1.assert message, &block
    assert result === true
  end
  
  def test_assert_two_args
    message = "my message here"
    bool    = 1==1
    result  = @foo1.assert bool, message
    assert result === true
  end
  
  def test_assert_fails
    message = "my message here"
    block   = Proc.new { 1==0 }
    assert_raise GUnit::AssertionFailure do
      @foo1.assert message, &block
    end
    begin
      @foo1.assert message, &block
    rescue GUnit::AssertionFailure => e
      assert_equal message, e.message
    end
  end
  
  def test_assert_fails_no_message
    block   = Proc.new { 1==0 }
    begin
      @foo1.assert &block
    rescue GUnit::AssertionFailure => e
      assert e.message =~ /false != true/
    end
  end
  
end