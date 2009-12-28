module GUnit
  
  class FailResponse < TestResponse
    
    DEFAULT_MESSAGE = 'Fail'
    
    attr_accessor :message
    
    # FailResponse.new("my message")
    # Verification.new()
    def initialize(msg=DEFAULT_MESSAGE)
      self.message = msg
    end
    
  end
  
end


