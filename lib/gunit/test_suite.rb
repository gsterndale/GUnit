module GUnit
  
  class TestSuite
    
    # TestCases (TODO and/or TestSuites)
    attr_writer :tests
    
    def initialize()
    end
    
    def tests
      @tests || []
    end
    
    def run(&blk)
      self.tests.each do |test|
        case
        when test.is_a?(TestSuite)
          test.run{|response| blk.call(response) if blk }
        when test.is_a?(TestCase)
          response = test.run
          blk.call(response) if blk
        end
      end
    end
    
  end
  
end