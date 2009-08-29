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
    
    def run
      begin
        if @task.is_a?(Proc)
          @task.call
          PassResponse.new
        else
          ToDoResponse.new
        end
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
      "Verification failed!"
    end
    
  end
  
end


