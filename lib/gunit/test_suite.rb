module GUnit
  
  class TestSuite
    
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