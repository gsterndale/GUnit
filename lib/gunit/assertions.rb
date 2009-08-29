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
      
      raise GUnit::AssertionFailure unless (actual.is_a?(Proc) && actual.call == expected) || actual == expected
      
      true
    end
    
  end
  
end