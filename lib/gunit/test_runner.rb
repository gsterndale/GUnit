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
    
    PASS_CHAR      = '.'
    FAIL_CHAR      = 'F'
    TODO_CHAR      = '*'
    EXCEPTION_CHAR = 'E'
    
    # TestSuites and/or TestCases
    attr_accessor :io, :silent
    attr_writer :tests
    attr_reader :responses
    
    def initialize(*args)
      @responses = []
      @io = STDOUT
      STDOUT.sync = true
      @silent = false
    end
    
    def tests
      @tests ||= []
    end
    
    def run
      self.tests.each do |test|
        case
        when test.is_a?(TestSuite)
          test.run do |response|
            @responses << response
            @io.print self.class.response_character(response) unless self.silent
          end
        when test.is_a?(TestCase)
          response = test.run
          @responses << response
          @io.print self.class.response_character(response) unless self.silent
        end
      end
      
      unless self.silent
        @io.puts ""
        @responses.each do |response|
          @io.puts "#{response.message} (#{response.file_name}:#{response.line_number})" unless response.is_a?(GUnit::PassResponse)
        end
        @io.puts "#{@responses.length} verifications: #{passes.length} passed, #{fails.length} failed, #{exceptions.length} exceptions, #{to_dos.length} to-dos"
      end
    end
    
    def passes
      @responses.find_all{|r| r.is_a? PassResponse }
    end
    
    def fails
      @responses.find_all{|r| r.is_a? FailResponse }
    end
    
    def exceptions
      @responses.find_all{|r| r.is_a? ExceptionResponse }
    end
    
    def to_dos
      @responses.find_all{|r| r.is_a? ToDoResponse }
    end
    
  protected
    
    def self.response_character(response)
      case
      when response.is_a?(PassResponse)
        PASS_CHAR
      when response.is_a?(FailResponse)
        FAIL_CHAR
      when response.is_a?(ExceptionResponse)
        EXCEPTION_CHAR
      when response.is_a?(ToDoResponse)
        TODO_CHAR
      end
    end
    
  end
  
end