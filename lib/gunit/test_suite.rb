module GUnit

  class TestSuite

    # TestCases and/or TestSuites
    attr_writer :tests

    def initialize()
    end

    def tests
      @tests ||= []
    end

  end

end