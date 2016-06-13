ENV['HIJACK_ENV'] = 'test'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "codeclimate-test-reporter"
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/lib/tasks/'
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ])
end

require 'hijack'
require 'byebug'
require 'forgery'
