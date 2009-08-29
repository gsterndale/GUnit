module GUnit
  
  # How many tests have run
  # How many passing test responses
  # How many failing test responses
  # How many exception test responses
  
  class TestRunner
    
    # TestSuites and/or TestCases
    attr_writer :tests
    
    def initialize()
    end
    
    def tests
      @tests || []
    end
    
    def run
      self.tests.each(&:run)
    end
    
  end
  
end