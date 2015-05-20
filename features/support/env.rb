# Add this gem's lib path to the $LOAD_PATH
$: << File.expand_path(File.join('..', '..', '..', 'lib'), __FILE__)

require 'ansibler'

require 'active_support/all'
require 'aruba/cucumber'
