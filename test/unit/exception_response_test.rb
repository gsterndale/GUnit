require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::ExceptionResponseTest < Test::Unit::TestCase
  
  def setup
    @exception_response1 = GUnit::ExceptionResponse.new
  end
  
  def test_it_is_a_test_response
    assert @exception_response1.is_a?(GUnit::TestResponse)
  end
  
  def test_has_default_message
    assert_not_nil @exception_response1.message
    assert @exception_response1.message != ''
    assert_equal GUnit::ExceptionResponse::DEFAULT_MESSAGE, @exception_response1.message
  end

end
