require 'singleton'

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

    include Singleton

    PASS_CHAR       = '.'
    FAIL_CHAR       = 'F'
    TODO_CHAR       = '*'
    EXCEPTION_CHAR  = 'E'
    PASS_COLOR      = "\e[0;32m"
    FAIL_COLOR      = "\e[0;31m"
    EXCEPTION_COLOR = "\e[0;31m"
    TODO_COLOR      = "\e[0;33m"
    DEFAULT_COLOR   = "\e[0m"

    DEFAULT_PATTERNS = ['test/**/*_test.rb', 'test/**/test_*.rb']

    # TestSuites and/or TestCases
    attr_accessor :io, :silent, :patterns
    attr_writer :tests, :autorun
    attr_reader :responses
    
    def initialize(*args)
      STDOUT.sync = true
      reset
    end

    def reset
      @io         = STDOUT
      @silent     = false
      @responses  = []
      @tests      = []
      @patterns   = DEFAULT_PATTERNS
      @autorun    = true
    end

    def discover
      files = self.patterns.inject([]){|memo, pattern| memo + Dir.glob(pattern) }.compact
      files.each {|file| Kernel.require file }
      self.tests = TestCase.subclasses.inject([]){|memo, test_case| memo << test_case.suite }.compact
    end

    def tests
      @tests ||= []
    end

    def autorun?
      ! @autorun.nil? && @autorun
    end

    def run!
      self.run if self.autorun?
    end

    def run
      self.print_test_cases_summary unless self.silent
      self.test_cases.each do |test_case|
        response = test_case.run
        @responses << response
        self.print_response_char(response) unless self.silent
      end
      self.print_responses_summary unless self.silent
    end
    
    def passes
      @responses.find_all{|response| response.is_a? PassResponse }
    end
    
    def fails
      @responses.find_all{|response| response.is_a? FailResponse }
    end
    
    def exceptions
      @responses.find_all{|response| response.is_a? ExceptionResponse }
    end
    
    def to_dos
      @responses.find_all{|response| response.is_a? ToDoResponse }
    end
    
  protected

    def print_test_cases_summary
      @io.puts test_case_classes.map{|klass| klass.to_s }.join(', ')
    end

    def print_response_char(response)
      @io.print self.class.response_color(response)
      @io.print self.class.response_character(response)
      @io.print DEFAULT_COLOR
    end

    def print_responses_summary
      @io.puts ""
      @responses.select{|response| !response.is_a?(GUnit::PassResponse) }.each do |response|
        @io.print self.class.response_color(response)
        @io.print "#{response.message} (#{response.file_name}:#{response.line_number})\n"
        @io.print DEFAULT_COLOR
      end
      @io.puts "#{@responses.length} verifications: #{passes.length} passed, #{fails.length} failed, #{exceptions.length} exceptions, #{to_dos.length} to-dos"
    end

    # Flatten array of TestSuites and TestCases into a single dimensional array of TestCases
    def test_cases(test_suites_cases=self.tests)
      test_suites_cases.map do |test|
        case test
        when GUnit::TestSuite
          test_cases(test.tests)
        when GUnit::TestCase
          test
        end
      end.flatten
    end

    # Unique TestCase subclasses
    def test_case_classes
      test_cases.map{|test| test.class }.uniq
    end

    def self.response_character(response)
      case response
      when PassResponse       then PASS_CHAR
      when FailResponse       then FAIL_CHAR
      when ExceptionResponse  then EXCEPTION_CHAR
      when ToDoResponse       then TODO_CHAR
      end
    end

    def self.response_color(response)
      case response
      when PassResponse       then PASS_COLOR
      when FailResponse       then FAIL_COLOR
      when ExceptionResponse  then EXCEPTION_COLOR
      when ToDoResponse       then TODO_COLOR
      end
    end
  end
  
end