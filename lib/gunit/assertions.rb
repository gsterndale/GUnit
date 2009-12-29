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
    
    def assert_raises(*args, &blk)
      expected = args[0]
      message  = args[1]
      
      begin
        blk.call
      rescue Exception => e
        actual = e
      end

      bool = case
      when actual.nil?
        false
      when expected.is_a?(String)
        actual.to_s == expected
      when expected.is_a?(Class)
        actual.is_a?(expected)
      when expected.nil?
        !actual.nil?
      else
        actual == expected
      end
      
      message ||= case
      when !expected.nil? && !actual.nil?
        "Expected #{expected.to_s} to be raised, but got #{actual.to_s}"
      when !expected.nil? && actual.nil?
        "Expected #{expected.to_s} to be raised, but nothing raised"
      else
        "Nothing raised"
      end
      
      assert bool, message
    end
    
  end
  
end