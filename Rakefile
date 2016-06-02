require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'byebug'


RSpec::Core::RakeTask.new { |t| t.rspec_opts='-t ~slow' }
desc 'Run slow tests'
RSpec::Core::RakeTask.new('spec:slow') { |t| t.rspec_opts='-t slow' }

task :default => :spec
