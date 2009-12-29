module GUnit
  
  class AssertionFailure < StandardError
  end
  
  module Assertions
    
    def assert(*args, &blk)
      expected = true
      
      if blk
        actual  = blk
        message = args[0] 
      else
        actual  = args[0]
        message = args[1]
      end
      
      actual = actual.call if actual.is_a?(Proc)
      
      unless actual == expected
        message ||= "#{actual.to_s} != #{expected.to_s}"
        raise GUnit::AssertionFailure.new(message)
      end
      
      true
    end
    
    def assert_equal(*args, &blk)
      expected = args[0]
      
      if blk
        actual  = blk
        message = args[1]
      else
        actual  = args[1]
        message = args[2]
      end
      
      actual = actual.call if actual.is_a?(Proc)
      
      message ||= "#{actual.to_s} != #{expected.to_s}"
      
      assert expected == actual, message
    end
    
    
  end
  
end