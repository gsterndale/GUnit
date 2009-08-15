require 'gunit/test_response'
require 'gunit/pass_response'
require 'gunit/fail_response'
require 'gunit/exception_response'

module GUnit
  
  class Verification
    attr_writer :message
    attr_accessor :expected, :actual
    attr_accessor :responses
    
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
      self.responses = []
    end
    
    def run(parent=nil)
      begin
        response = if self.matches?
          PassResponse.new
        else
          FailResponse.new
        end
      rescue ::StandardError => e
        response = ExceptionResponse.new
      end
      parent.responses << response if parent
      response
    end
    
    
    def message
      @message || default_message
    end
    
    def matches?
      if @actual.is_a?(Proc)
        returned = @actual[self]
        returned == @expected || returned.is_a?(PassResponse)
      else
        @actual == @expected
      end
    end
    
    def default_message
      "Verification failed!"
    end
    
  end
  
end


