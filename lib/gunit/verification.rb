module GUnit
  
  class Verification
    attr_writer :message
    attr_accessor :expected, :actual
    
    # Verification.new(true, "message")
    # Verification.new(true)
    # Verification.new("message") { true }
    def initialize(*args, &blk)
      case args.length
      when 1
        if blk
          self.actual  = blk
          self.message = args[0]
        else
          self.actual = args[0]
        end
      when 2
        self.actual  = args[0]
        self.message = args[1]
      else
        self.actual  = args[0]
        self.message = args[1]
      end
      self.expected = true
    end
    
    def message
      @message || default_message
    end
    
    def matches?
      (@actual.is_a?(Proc) ? @actual.call : @actual) == @expected
    end
    
    def default_message
      "Verification failed!"
    end
    
  end
  
end


