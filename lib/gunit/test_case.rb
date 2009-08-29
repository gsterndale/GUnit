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
    
    TEST_METHOD_PREFIX = 'test_'
    
    attr_accessor :method_name
    @@method_count = 0
    
    def initialize(method=nil)
      self.method_name = method
    end
    
    def run
      self.send(self.method_name.to_sym)
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
      method_names.map!{|m| m.to_sym }
    end
    
    def self.verify(*args, &blk)
      test_method_name = unique_test_method_name
      define_method(test_method_name) do
        verification = if blk
          GUnit::Verification.new(args.first, blk)
        else
          GUnit::Verification.new(args.first)
        end
        verification.run
      end
      test_method_name
    end
    
  protected
    
    def self.unique_test_method_name(name="")
      "#{TEST_METHOD_PREFIX}#{name}_#{@@method_count+=1}".to_sym
    end
    
  end
  
end