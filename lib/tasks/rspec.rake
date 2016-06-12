require "rspec/core/rake_task"

desc 'Run tests'
RSpec::Core::RakeTask.new('spec' => 'db:rebuild') { |t| t.rspec_opts='-t ~slow' }

desc 'Run (also) slow tests'
RSpec::Core::RakeTask.new('spec:slow' => 'db:rebuild')

desc 'Run (only) slow tests'
RSpec::Core::RakeTask.new('spec:slow:only' => 'db:rebuild') { |t| t.rspec_opts='-t slow' }
