module GUnit
  
  class FailResponse < TestResponse
    
    DEFAULT_MESSAGE = 'Fail'
    
    attr_accessor :message
    attr_reader :backtrace, :line_number, :file_name
    
    # FailResponse.new("my message")
    def initialize(*args)
      self.message = args.find{|a| a.is_a?(String) } || DEFAULT_MESSAGE
      self.backtrace = args.find{|a| a.is_a?(Array) } || []
    end
    
    def backtrace=(a=[])
      @backtrace = a
      @line_number = nil
      @backtrace.find do |trace|
        trace =~ /([\w\.]+):(\d+):/
        $1 != 'assertions.rb' and @file_name = $1 and @line_number = $2 and @file_name = $1
      end
      @line_number = @line_number ? @line_number.to_i : nil
      @backtrace
    end
    
  end
  
end


