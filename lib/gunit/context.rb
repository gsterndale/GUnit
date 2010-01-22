module GUnit
  # Context instance has message, setups, exercises, teardowns, and parent (another Context)
  class Context
    attr_accessor :task, :parent, :message, :setups, :teardowns
    
    # Context.new("my message")
    # Context.new("my message") do
    #   setup { @foo = "bar" }
    #   verify { true }
    # end
    # Context.new do
    #   setup { @foo = "bar" }
    #   verify { true }
    # end
    def initialize(*args, &blk)
      self.message    = args[0] || ''
      self.setups     = []
      self.teardowns  = []
      self.task = blk if blk
    end
    
    def run(binding=self)
      if @task.is_a?(Proc)
        bound_task = @task.bind(binding)
        bound_task.call
      end
      return true
    end
    
    def all_message
      parent_message = self.parent.all_message if self.parent
      parent_message = nil if parent_message == ''
      [parent_message, @message].compact.join(' ')
    end
    
    def all_setups
      (self.parent ? self.parent.all_setups : []) + @setups
    end
    
    def all_teardowns
      (self.parent ? self.parent.all_teardowns : []) + @teardowns
    end
    
  end
  
end