require 'gunit/context'
require 'gunit/exercise'
require 'gunit/setup'
require 'gunit/teardown'
require 'gunit/verification'

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
    attr_accessor :method_name
    
    def initialize(method=nil)
      self.method_name = method
    end
    
    def run
      self.send(self.method_name.to_sym)
    end
    
    # def self.suite
    #   # Create an new instance of self.class for each test method and add them to a TestSuite Object
    # end
    
  end
  
end