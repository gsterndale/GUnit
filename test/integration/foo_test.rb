require File.join(File.dirname(__FILE__), '..', 'test_helper')

class Foo
end

class FooGUnitTest < GUnit::TestCase
  
  setup do
    @foo = 'bar'
  end
  
  verify "variable from setup" do
    assert @foo == 'bar'
    assert "foo is string" do
      @foo.is_a?(String)
    end
    assert @foo.is_a?(String), "foo is string"
    assert_equal 'bar', @foo, "foo is bar"
  end
  
  verify do
    assert 1 == 1
  end
  
  verify "truth" do
    assert true
    
    assert "one is one" do
      1 == 1
    end
    
    assert_equal 1, 1
    assert_equal 1, 1, "one is one"
    assert_equal 1 do
      0 + 1
    end
    assert_equal 2, "one and one make two" do
      1 + 1
    end
    assert_equal 2 do
      1 + 1
    end
  end
  
  verify "failure here" do
    assert false
  end

  verify "another failure here" do
    assert @foo == 'wrong'
  end
  
  verify "exceptional" do
    assert_raises do
      raise "BOOM!"
    end
  end
  
  verify "not exceptional" do
    assert_raises do
      true
    end
  end
  
  verify "unexpected" do
    raise "BAM!!!"
  end
  
  verify "not dun yet"
  
  context "An instance of Foo" do
    # One setup per context
    setup do
      @foo = 'abc'
    end
    
    # # One exercise per context
    # exercise do
    #   @foo.do_something
    # end
  
    # One teardown per context
    teardown do
      @foo = nil
    end
    
    # Many verifies per context
    verify "abc's of foo" do
      assert @foo == 'abc'
    end
    
    # many nested contexts per context
    context "doing something else" do
      setup do
        @foo = 'xyz'
      end
      teardown do
        @foo = nil
      end
      verify "xyz's of foo" do
        assert @foo == 'xyz'
      end
      verify "xyz's of foo" do
        assert @foo == 'wrong'
      end
    end
    
    verify "abc's of foo" do
      assert @foo == 'def'
    end
  end
  
  # # Custom macros
  # verify_validity @foo
  # verify_dirty @foo
  # 
  # # Many verifies per context, some share fixtures
  # # setup, exercise and teardown will only be run once for all methods in this context with the second param == true
  # verify "one and one is two", true do
  #   assert 1+1 == 2
  # end
  # 
  # # Many verifies per context, some share fixtures
  # # setup, exercise and teardown will only be run once for all methods in this context with the second param == true
  # verify "one is more than none", true do
  #   assert 1 > 0
  # end
  #   
  # # Many verifies per context
  # verify "the truth" do
  #   assert { true }
  #   assert "true is true" { true }
  #   assert true
  #   assert_equal true, true
  #   assert_equal true, true, "true is true"
  #   assert_equal true, true, "true is true" {|a,b| a === b }
  #   
  #   assert_is_a @foo, Foo
  # 
  #   assert_nil nil
  # 
  #   assert_nil nil, "nil is nil"
  # 
  #   assert_raise do
  #     raise RuntimeError
  #   end
  # 
  #   assert_raise RuntimeError do
  #     raise RuntimeError
  #   end
  # 
  #   assert_raise RuntimeError, "blow up" do
  #     raise RuntimeError
  #   end
  # end
  # 
  # verify "something changed" do
  #   assert_change @foo.something, :by => -1
  #   assert_change "@foo.something_else", :from => true, :to => false
  #   assert_change "@foo.third_thing" {|before, after| before < after }
  # end
  
end

class FooGUnitTestTest < Test::Unit::TestCase
  def setup
    @test_runner = GUnit::TestRunner.new
    @test_runner.io = mock('io')
    @test_runner.io.stubs(:print)
    @test_runner.io.stubs(:puts)
    @test_runner.tests << FooGUnitTest.suite
  end
  
  def test_run_test_runner
    @test_runner.run
    assert_equal 6, @test_runner.passes.length
    assert_equal 5, @test_runner.fails.length
    assert_equal 1, @test_runner.exceptions.length
    assert_equal 1, @test_runner.to_dos.length
  end
  
end