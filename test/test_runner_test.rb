require 'test_helper'

class GUnit::TestRunnerTest < Test::Unit::TestCase
  
  def setup
    @test_runner = GUnit::TestRunner.new
  end
  
  def test_it_is_a_test_runner
    assert @test_runner.is_a?(GUnit::TestRunner)
  end
  
  def test_suites_getter_setter
    suites = [GUnit::TestSuite.new, GUnit::TestCase.new]
    assert @test_runner.suites != suites
    @test_runner.suites = suites
    assert @test_runner.suites == suites
  end
  
  
  
end
