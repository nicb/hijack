require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'byebug'


RSpec::Core::RakeTask.new { |t| t.rspec_opts='-t ~slow' }
desc 'Run (also) slow tests'
RSpec::Core::RakeTask.new('spec:slow')
desc 'Run (only) slow tests'
RSpec::Core::RakeTask.new('spec:slow:only') { |t| t.rspec_opts='-t slow' }

task :default => :spec
