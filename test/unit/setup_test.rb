require File.join(File.dirname(__FILE__), '..', 'test_helper')

# class MyClassTest < GUnit::TestCase
#   setup "Some fixtures should be created here"
#   
#   context "An instance of MyClass"
#     setup "my fixture with attributes" do
#       ...
#     end
#   end
# end

class GUnit::SetupTest < Test::Unit::TestCase

  def setup
    @setup1 = GUnit::Setup.new
  end

  def test_it_is_a_groundwork
    assert @setup1.is_a?(GUnit::Groundwork)
  end

  def test_has_default_message
    assert_not_nil @setup1.message
    assert_equal 'Setup', @setup1.message
  end

end
