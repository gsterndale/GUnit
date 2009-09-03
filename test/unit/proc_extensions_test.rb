require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GUnit::ProcExtensionsTest < Test::Unit::TestCase
  
  @@proc = Proc.new { bound_to }
  
  def self.bound_to
    :class
  end
  
  def bound_to
    :instance
  end
  
  def test_bind
    p = @@proc
    assert self.class.bound_to == :class
    assert p.call == :class
    p = p.bind(self)
    assert self.bound_to == :instance
    assert p.call == :instance
  end
  
end
