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
  
  def test_responses_setter_getter
    responses = ["Foo"]
    assert_not_equal responses, @verification1.responses
    @verification1.responses = responses
    assert_equal responses, @verification1.responses
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
  
  def test_failing_nested_verification
    @verification2 = GUnit::Verification.new("top message"){|parent|
      GUnit::Verification.new(false).run(parent)
    }
    response = @verification2.run
    assert response.is_a?(GUnit::FailResponse)
    assert @verification2.responses.is_a?(Array)
    assert !@verification2.responses.empty?
    assert @verification2.responses[0].is_a?(GUnit::FailResponse)
  end
  
  def test_passing_nested_verification
    @verification2 = GUnit::Verification.new("top message"){|parent|
      GUnit::Verification.new(true).run(parent)
    }
    response = @verification2.run
    assert response.is_a?(GUnit::PassResponse)
    assert @verification2.responses.is_a?(Array)
    assert !@verification2.responses.empty?
    assert @verification2.responses[0].is_a?(GUnit::PassResponse)
  end
  
  def test_passing_nested_verifications
    @verification2 = GUnit::Verification.new("top message"){|parent|
      GUnit::Verification.new(true).run(parent)
      GUnit::Verification.new(true).run(parent)
    }
    response = @verification2.run
    assert response.is_a?(GUnit::PassResponse)
    assert @verification2.responses.is_a?(Array)
    assert_equal 2, @verification2.responses.length
    assert @verification2.responses.all?{|r| r.is_a?(GUnit::PassResponse) }
  end
  
  def test_failing_nested_verifications
    @verification2 = GUnit::Verification.new("top message"){|parent|
      GUnit::Verification.new(false).run(parent)
      GUnit::Verification.new(false).run(parent)
    }
    response = @verification2.run
    assert response.is_a?(GUnit::FailResponse)
    assert @verification2.responses.is_a?(Array)
    assert_equal 2, @verification2.responses.length
    assert @verification2.responses.all?{|r| r.is_a?(GUnit::FailResponse) }
  end
  
  def test_failing_and_passing_nested_verifications
    @verification2 = GUnit::Verification.new("top message"){|parent|
      GUnit::Verification.new(true).run(parent)
      GUnit::Verification.new(false).run(parent)
    }
    response = @verification2.run
    assert response.is_a?(GUnit::FailResponse)
    assert @verification2.responses.is_a?(Array)
    assert_equal 2, @verification2.responses.length
    assert @verification2.responses.detect{|r| r.is_a?(GUnit::FailResponse) }
    assert @verification2.responses.detect{|r| r.is_a?(GUnit::PassResponse) }
  end
  
  def test_run_with_true_match
    @verification1.actual = true
    assert @verification1.matches?
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::PassResponse)
  end
  
  def test_run_with_false_match
    @verification1.actual = false
    assert !@verification1.matches?
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::FailResponse)
  end
  
  def test_run_with_raising_match
    @verification1.actual = lambda{ raise StandardError }
    assert_raise(StandardError) {@verification1.matches?}
    response = @verification1.run
    assert response.is_a?(GUnit::TestResponse)
    assert response.is_a?(GUnit::ExceptionResponse)
  end
  
  
end
