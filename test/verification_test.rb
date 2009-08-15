require 'test_helper'

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
  
  def test_expected_setter_getter
    expected = "123"
    assert_not_equal expected, @verification1.expected
    @verification1.expected = expected
    assert_equal expected, @verification1.expected
  end
  
  def test_actual_setter_getter
    actual = "321"
    assert_nil @verification1.actual
    @verification1.actual = actual
    assert_equal actual, @verification1.actual
  end
  
  def test_matches?
    @verification1.expected = "123"
    @verification1.actual = "321"
    assert ! @verification1.matches?
    @verification1.actual = "123"
    assert @verification1.matches?
  end
  
  def test_matches_with_actual_as_block
    @verification1.expected = "123"
    @verification1.actual = lambda{"321"}
    assert ! @verification1.matches?
    @verification1.actual = lambda{"123"}
    assert @verification1.matches?
    
    @verification1.expected = "123"
    @verification1.actual = Proc.new{"321"}
    assert ! @verification1.matches?
    @verification1.actual = Proc.new{"123"}
    assert @verification1.matches?
  end
  
  def test_initialize_with_one_arg
    actual = "Foo"
    @verification2 = GUnit::Verification.new(actual)
    assert @verification2.default_message === @verification2.message 
    assert actual === @verification2.actual
    assert true === @verification2.expected
  end
  
  def test_initialize_with_one_arg_and_block
    actual  = "Foo"
    message = "Bar"
    @verification2 = GUnit::Verification.new(message) { actual }
    assert message === @verification2.message
    assert actual === @verification2.actual.call
    assert true === @verification2.expected
  end
  
  def test_initialize_with_two_args
    actual  = "Foo"
    message = "Bar"
    @verification2 = GUnit::Verification.new(actual, message)
    assert message === @verification2.message 
    assert actual === @verification2.actual
    assert true === @verification2.expected
  end
  
  # def test_nested_verifications
  #   @verification2 = GUnit::Verification.new(message){
  #     @verification3 = GUnit::Verification.new(true)
  #     @verification4 = GUnit::Verification.new(false)
  #   }
  # end
  
  def test_run_with_true_match
    @verification1.actual = true
    assert @verification1.matches?
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::Pass)
    
  end
  
  def test_run_with_false_match
    
  end
  
  def test_run_with_raising_match
    
  end
  
  
end
