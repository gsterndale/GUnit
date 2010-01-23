require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::PassResponseTest < Test::Unit::TestCase
  
  def setup
    @pass_response1 = GUnit::PassResponse.new
  end
  
  def test_it_is_a_test_response
    assert @pass_response1.is_a?(GUnit::TestResponse)
  end
  
  def test_has_default_message
    assert_not_nil @pass_response1.message
    assert @pass_response1.message != ''
    assert_equal GUnit::PassResponse::DEFAULT_MESSAGE, @pass_response1.message
  end

end
