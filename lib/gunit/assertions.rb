module GUnit
  
  module Assertions
    
    def assert(*args, &blk)
      expected = true
      
      # args.flatten! # TODO may need to be smarter about when this happens
      if blk
        actual  = blk
        message = args[0] 
      else
        actual  = args[0]
        message = args[1]
      end
      
      begin
        match = (actual.is_a?(Proc) && actual.call == expected) || actual == expected
        
        response = if match
          PassResponse.new
        else
          FailResponse.new
        end
      rescue ::StandardError => e
        response = ExceptionResponse.new
      end
      response
    end
    
  end
  
end