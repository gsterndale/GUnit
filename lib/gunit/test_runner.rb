module GUnit
  
  # How many tests have run
  # How many passing test responses
  # How many failing test responses
  # How many exception test responses
  
  # A TestRunner object discovers TestCase classes
  # The TestRunner object calls suite() on all TestCase classes
  # Each TestCase class returns a TestSuite object with instances of itself (TestCases) each with a method to be executed
  # The TestRunner object calls run() on all TestSuite objects, collecting TestResponses
  # Each TestSuite object calls run() on all of its TestCase objects, yielding TestResponses
  # Each TestCase object executes its method, returning a TestResponse
  # The TestRunner displays the TestResponses as they are yielded
  # After all tests have run, the TestRunner displays a summery of results
  
  class TestRunner
    
    # TestSuites and/or TestCases
    attr_writer :tests
    attr_reader :responses
    
    def initialize(*args)
      @responses = []
    end
    
    def tests
      @tests || []
    end
    
    def run
      self.tests.each do |test|
        case
        when test.is_a?(TestSuite)
          test.run{|response| @responses << response }
        when test.is_a?(TestCase)
          @responses << test.run
        end
      end
    end
    
  end
  
end