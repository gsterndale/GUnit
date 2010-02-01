module GUnit
  
  class TestResponse
    
    DEFAULT_MESSAGE = ''
    
    attr_accessor :message
    attr_reader :backtrace, :line_number, :file_name
    
    # FailResponse.new("my message")
    def initialize(*args)
      self.message = args.find{|arg| arg.is_a?(String) } || self.class::DEFAULT_MESSAGE
      self.backtrace = args.find{|arg| arg.is_a?(Array) } || []
    end
    
    def backtrace=(traces=[])
      @backtrace = traces
      discover_file_name
      discover_line_number
      @backtrace
    end
    
  protected
    
    def discover_line_number
      return @line_number = nil if self.scrubbed_backtrace.empty?
      self.scrubbed_backtrace.first =~ /[\/\w\.]+:(\d+)/
      @line_number = $1
      @line_number = @line_number ? @line_number.to_i : nil
    end
    
    def discover_file_name
      return @file_name = nil if self.scrubbed_backtrace.empty?
      self.scrubbed_backtrace.first =~ /([\w\.]+):\d+/
      @file_name = $1
    end
    
    def scrubbed_backtrace
      @backtrace.select do |trace|
        !self.class.blacklisted?(trace)
      end
    end
    
    def self.blacklisted?(trace)
      trace =~ /\A([\/\w\.]+):\d+.+\z/
      path = $1
      return false unless path
      dir = path.split('/')[-2]
      dir && dir == 'gunit'
    end
    
  end
  
end


