module GUnit
  
  class Verification
    attr_writer :message
    attr_accessor :task
    
    # Verification.new("my message")
    # Verification.new("my message") { assert true }
    # Verification.new() { assert true }
    def initialize(*args, &blk)
      self.message = args[0]
      self.task = blk if blk
    end
    
    def run(binding=self)
      begin
        if @task.is_a?(Proc)
          bound_task = @task.bind(binding)
          bound_task.call
          PassResponse.new
        else
          ToDoResponse.new(self.message, Kernel.caller)
        end
      rescue GUnit::AssertionFailure => e
        FailResponse.new(e.message, e.backtrace)
      rescue ::Exception => e
        ExceptionResponse.new(e.message, e.backtrace)
      end
    end
    
    def message
      @message || default_message
    end
    
    def default_message
      "Verification failed!"
    end
    
  end
  
end


