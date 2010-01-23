require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::FailResponseTest < Test::Unit::TestCase
  
  def setup
    @fail_response1 = GUnit::FailResponse.new
  end
  
  def test_it_is_a_test_response
    assert @fail_response1.is_a?(GUnit::TestResponse)
  end
  
  def test_has_default_message
    assert_not_nil @fail_response1.message
    assert @fail_response1.message != ''
    assert_equal GUnit::FailResponse::DEFAULT_MESSAGE, @fail_response1.message
  end

end
