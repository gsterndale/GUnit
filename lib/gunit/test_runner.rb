module GUnit
  
  # How many tests have run
  # How many passing test responses
  # How many failing test responses
  # How many exception test responses
  
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