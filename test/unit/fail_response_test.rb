require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::FailResponseTest < Test::Unit::TestCase
  
  def setup
    @fail_response1 = GUnit::FailResponse.new
  end
  
  def test_it_is_a_fail_response
    assert @fail_response1.is_a?(GUnit::FailResponse)
  end
  
  def test_has_default_message
    assert_not_nil @fail_response1.message
    assert @fail_response1.message != ''
  end
  
  def test_message_setter
    message = "Whoops."
    @fail_response1.message = message
    assert_equal message, @fail_response1.message
  end
  
  # FailResponse.new('my fixtures')
  def test_initialize_with_one_arg
    message = 'Uhohs'
    @fail_response2 = GUnit::FailResponse.new(message)
    assert @fail_response2.message === message
  end
  
end
