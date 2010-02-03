module GUnit
  # Acts as a TestSuite Factory
  # Creates a TestCase Object for each Test Method
  # Adds all TestCase Objects onto a TestSuite Object
  # The TestSuite Object will be used by a TestRunner
  
  # Each TestCase Object of the TestCase Class have a way to determine which Test Method it should invoke.
  # Pluggable Behavior is the most common way to do this. 
  # The constructor of the TestCase Class takes the name of the method to be invoked as a parameter and store this name in an instance variable.
  # When the Test Runner invokes the run method on the TestCase Object, it uses reflection to find and invoke the method whose name is in the instance variable.
  
  # count, run, display
  class TestCase
    include Assertions

    TEST_METHOD_PREFIX = 'test'
    
    attr_accessor :method_name
    attr_writer :context
    
    @@method_count          = 0
    @@context_stack         = [ GUnit::Context.new ]
    @@test_method_contexts  = {}
    @@autorun               = true
    @@subclasses            = []

    def initialize(method=nil)
      self.method_name = method
    end

    def self.subclasses
      @@subclasses
    end

    def self.inherited(subclass)
      subclasses << subclass
      # autorun must happen at exit, otherwise the subclass won't be loaded
      at_exit { subclass.autorun }
    end

    def self.autorun=(bool)
      @@autorun = !bool.nil? && bool
    end

    def self.autorun?
      @@autorun
    end

    def self.autorun
      if GUnit::TestCase.autorun?
        test_runner = GUnit::TestRunner.instance
        test_runner.tests << suite
        test_runner.run!
      end
    end

    def self.suite
      # Create an new instance of self.class for each test method and add them to a TestSuite Object
      test_suite = TestSuite.new
      test_methods.each do |test_method|
        test_suite.tests << new(test_method)
      end
      test_suite
    end

    def self.test_methods(prefix=TEST_METHOD_PREFIX)
      method_names = instance_methods.find_all{|method| method =~ /\A#{prefix}/ && ! GUnit::TestCase.instance_methods.include?(method) }
      method_names.map!{|method_name| method_name.to_sym }
    end
    
    def self.context_for_method(method_name)
      @@test_method_contexts[method_name] || @@context_stack.first
    end
    
    def self.context(*args, &blk)
      new_context = if blk
        GUnit::Context.new(args.first, &blk)
      else
        GUnit::Context.new(args.first)
      end
      new_context.parent = current_context
      @@context_stack << new_context
      current_context.run(self)
      @@context_stack.pop
    end
    
    def self.setup(*args, &blk)
      setup = if blk
        GUnit::Setup.new(args.first, &blk)
      else
        GUnit::Setup.new(args.first)
      end
      current_context.setups << setup
    end
    
    def self.exercise(*args, &blk)
      exercise = if blk
        GUnit::Exercise.new(args.first, &blk)
      else
        GUnit::Exercise.new(args.first)
      end
      current_context.exercise = exercise
    end
    
    def self.teardown(*args, &blk)
      teardown = if blk
        GUnit::Teardown.new(args.first, &blk)
      else
        GUnit::Teardown.new(args.first)
      end
      current_context.teardowns << teardown
    end
    
    def self.verify(*args, &blk)
      test_method_name = message_to_unique_test_method_name(args.first)
      define_method(test_method_name) do
        verification = GUnit::Verification.new(args.first, &blk)
        verification.run(self)
        GUnit::PassResponse.new(verification.message)
      end
      @@method_count += 1
      @@test_method_contexts[test_method_name] = current_context
      test_method_name
    end
    
    def self.message_to_test_method_name(msg)
      if msg && msg != ''
        [TEST_METHOD_PREFIX, msg.downcase.gsub(/ |@/,'_')].join('_').to_sym
      else
        TEST_METHOD_PREFIX.to_sym
      end
    end

    def context
      self.class.context_for_method(self.method_name)
    end

    def run
      self.run_setups
      self.run_excercise
      response = self.send(self.method_name.to_sym)
      self.run_teardowns
    rescue GUnit::NothingToDo => e
      response = ToDoResponse.new(e.message, e.backtrace)
    rescue GUnit::AssertionFailure => e
      response = FailResponse.new(e.message, e.backtrace)
    rescue ::Exception => e
      response = ExceptionResponse.new(e.message, e.backtrace)
    ensure
      return response
    end

  protected
  	
    def run_setups
      self.context.all_setups.each {|setup| setup.run(self) }
    end
    
    def run_excercise
      self.context.exercise.run(self) if self.context && self.context.exercise
    end
    
    def run_teardowns
      self.context.all_teardowns.reverse.each {|teardown| teardown.run(self) } if self.context
    end
    
    def self.current_context
      @@context_stack.last
    end

    def self.message_to_unique_test_method_name(msg)
      name = message_to_test_method_name(msg)
      if method_defined?(name)
        name = [name.to_s, (@@method_count+1).to_s].join('_').to_sym
      end
      name
    end

  end

end