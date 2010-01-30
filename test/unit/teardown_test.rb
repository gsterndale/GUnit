require File.join(File.dirname(__FILE__), '..', 'test_helper')

# class MyClassTest < GUnit::TestCase
#   teardown "Delete some fixtures here"
#   
#   context "An instance of MyClass"
#     teardown "delete my fixture" do
#       ...
#     end
#   end
# end

class GUnit::TeardownTest < Test::Unit::TestCase

  def setup
    @teardown1 = GUnit::Teardown.new
  end

  def test_it_is_a_groundwork
    assert @teardown1.is_a?(GUnit::Groundwork)
  end

  def test_has_default_message
    assert_not_nil @teardown1.message
    assert_equal 'Teardown', @teardown1.message
  end

end
