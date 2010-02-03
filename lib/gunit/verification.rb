module GUnit

  class NothingToDo < StandardError
  end

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
      raise GUnit::NothingToDo.new(self.message) unless @task.is_a?(Proc) # Kernel.caller
      bound_task = @task.bind(binding)
      bound_task.call
    end
    
    def message
      @message || default_message
    end
    
    def default_message
      "Verification failed!"
    end
    
  end
  
end


