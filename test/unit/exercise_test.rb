require File.join(File.dirname(__FILE__), '..', 'test_helper')

# class MyClassTest < GUnit::TestCase
#   exercise "Some fixtures should be created here"
#   
#   context "An instance of MyClass"
#     setup "a Foo with a name" do
#       @foo = Foo.new("a foo")
#     end
#     exercise "renamed" do
#       @foo.rename("the foo")
#     end
#   end
# end

class GUnit::ExerciseTest < Test::Unit::TestCase
  
  def setup
    @exercise1 = GUnit::Exercise.new
  end
  
  def test_it_is_a_groundwork
    assert @exercise1.is_a?(GUnit::Groundwork)
  end
  
  def test_has_default_message
    assert_not_nil @exercise1.message
    assert_equal 'Exercise', @exercise1.message
  end

end
