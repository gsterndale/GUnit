require 'rubygems'
require 'ruby-debug'
require File.join(File.dirname(__FILE__), '..', 'martini')

# Let's use this version of GUnit, instead of whatever may be install via Gem
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'gunit')
# require 'GUnit'