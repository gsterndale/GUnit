module GUnit
  
  class Verification
    attr_writer :message
    attr_accessor :expected, :actual
    
    # Verification.new(true, "message")
    # Verification.new(true)
    # Verification.new("message") { true }
    def initialize(*args, &blk)
      # args.flatten! # TODO may need to be smarter about when this happens
      if blk
        self.actual  = blk
        self.message = args[0] 
      else
        self.actual  = args[0]
        self.message = args[1]
      end
      self.expected = true
    end
    
    def run
      begin
        response = if self.matches?
          PassResponse.new
        else
          FailResponse.new
        end
      rescue ::StandardError => e
        response = ExceptionResponse.new
      end
      response
    end
    
    def message
      @message || default_message
    end
    
    def matches?
      if @actual.is_a?(Proc)
        @actual.call == @expected
      else
        @actual == @expected
      end
    end
    
    def default_message
      "Verification failed!"
    end
    
  end
  
end


