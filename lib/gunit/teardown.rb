module GUnit
  
  class Teardown
    attr_writer :message
    attr_accessor :task
    
    # Teardown.new("my message")
    # Teardown.new("my message") { @foo = "bar" }
    # Teardown.new() { @foo = "bar" }
    def initialize(*args, &blk)
      self.message = args[0]
      self.task = blk if blk
    end
    
    def run(binding=self)
      begin
        if @task.is_a?(Proc)
          bound_task = @task.bind(binding)
          bound_task.call
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
      "Teardown"
    end
    
  end
  
end


