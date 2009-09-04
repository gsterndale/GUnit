module GUnit
  
  class Setup
    attr_writer :message
    attr_accessor :task
    
    # Setup.new("my message")
    # Setup.new("my message") { @foo = "bar" }
    # Setup.new() { @foo = "bar" }
    def initialize(*args, &blk)
      self.message = args[0]
      self.task = blk if blk
    end
    
    def run(binding=self)
      begin
        if @task.is_a?(Proc)
          @task = @task.bind(binding)
          @task.call
        end
        return true
      rescue GUnit::AssertionFailure => e
        FailResponse.new
      rescue ::StandardError => e
        ExceptionResponse.new
      end
    end
    
    def message
      @message || default_message
    end
    
    def default_message
      "Setup"
    end
    
  end
  
end


