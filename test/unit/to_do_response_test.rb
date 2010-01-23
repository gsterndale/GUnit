require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::ToDoResponseTest < Test::Unit::TestCase
  
  def setup
    @to_do_response1 = GUnit::ToDoResponse.new
  end
  
  def test_it_is_a_test_response
    assert @to_do_response1.is_a?(GUnit::TestResponse)
  end
  
  def test_has_default_message
    assert_not_nil @to_do_response1.message
    assert @to_do_response1.message != ''
    assert_equal GUnit::ToDoResponse::DEFAULT_MESSAGE, @to_do_response1.message
  end

end
