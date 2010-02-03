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
  
  def test_assert_equal_two_args
    expected = 1
    actual   = 1
    result   = @foo1.assert_equal expected, actual
    assert result === true
  end
  
  def test_assert_equal_one_arg_one_block
    expected = 1
    block    = Proc.new { 0 + 1 }
    result   = @foo1.assert_equal expected, &block
    assert result === true
  end
  
  def test_assert_equal_two_args_one_block
    expected = 1
    block    = Proc.new { 0 + 1 }
    message  = "my message here"
    result   = @foo1.assert_equal expected, message, &block
    assert result === true
  end
  
  def test_assert_equal_fails
    expected  = 2
    message   = "my message here"
    block     = Proc.new { 0 + 1 }
    assert_raise GUnit::AssertionFailure do
      @foo1.assert_equal expected, message, &block
    end
    begin
      @foo1.assert_equal expected, message, &block
    rescue GUnit::AssertionFailure => e
      assert_equal message, e.message
    end
  end
  
  def test_assert_equal_fails_no_message
    expected  = 2
    block     = Proc.new { 0 + 1 }
    begin
      @foo1.assert_equal expected, &block
    rescue GUnit::AssertionFailure => e
      assert e.message =~ /1 != 2/
    end
  end
  
  def test_assert_raises_string_message_block
    block     = Proc.new { raise "boom" }
    expected  = "boom"
    message   = "my message here"
    result    = @foo1.assert_raises expected, message, &block
    assert result === true
  end
  
  def test_assert_raises_class_message_block
    block     = Proc.new { raise StandardError }
    expected  = StandardError
    message   = "my message here"
    result    = @foo1.assert_raises expected, message, &block
    assert result === true
  end
  
  def test_assert_raises_string_block
    block     = Proc.new { raise "boom" }
    expected  = "boom"
    result    = @foo1.assert_raises expected, &block
    assert result === true
  end
  
  def test_assert_raises_block_only
    block   = Proc.new { raise "boom" }
    result  = @foo1.assert_raises &block
    assert result === true
  end
  
  def test_assert_raises_fails
    block     = Proc.new { raise "POWWWW" }
    expected  = "boom"
    message   = "my message here"
    assert_raise GUnit::AssertionFailure do
      @foo1.assert_raises expected, message, &block
    end
    begin
      @foo1.assert_raises expected, message, &block
    rescue GUnit::AssertionFailure => e
      assert_equal message, e.message
    end
  end
  
  def test_assert_raises_with_class_fails
    block     = Proc.new { raise Exception }
    expected  = StandardError
    message   = "my message here"
    assert_raise GUnit::AssertionFailure do
      @foo1.assert_raises expected, message, &block
    end
    begin
      @foo1.assert_raises expected, message, &block
    rescue GUnit::AssertionFailure => e
      assert_equal message, e.message
    end
  end
  
  def test_assert_raises_fails_no_message
    block     = Proc.new { raise Exception }
    expected  = StandardError
    begin
      @foo1.assert_raises expected, &block
    rescue GUnit::AssertionFailure => e
      assert e.message =~ /Expected StandardError to be raised, but got Exception/
    end
  end
  
  def test_assert_raises_fails_nothing_raised_no_message
    block     = Proc.new { true }
    expected  = StandardError
    begin
      @foo1.assert_raises expected, &block
    rescue GUnit::AssertionFailure => e
      assert e.message =~ /Expected StandardError to be raised, but nothing raised/
    end
  end
  
  def test_assert_raises_fails_no_expected_nothing_raised
    block     = Proc.new { true }
    assert_raise GUnit::AssertionFailure do
      @foo1.assert_raises &block
    end
    begin
      @foo1.assert_raises &block
    rescue GUnit::AssertionFailure => e
      assert e.message =~ /Nothing raised/
    end
  end
  
end