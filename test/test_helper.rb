require 'rubygems'
require 'test/unit'
require 'erb'
require 'mocha'
require 'ruby-debug'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'gunit'

class Test::Unit::TestCase
  GUnit::TestCase.autorun = false
end
