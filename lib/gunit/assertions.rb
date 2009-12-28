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
      
      unless ((actual.is_a?(Proc) && actual.call == expected) || actual == expected)
        message ||= "#{(actual.is_a?(Proc) ? actual.call : actual).to_s} != #{expected.to_s}"
        raise GUnit::AssertionFailure.new(message)
      end
      
      true
    end
    
  end
  
end