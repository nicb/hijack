require "bundler/gem_tasks"
require 'byebug'

task :default => :spec

Dir.glob(File.expand_path(File.join('..', 'lib',  'tasks', '**', '*.rake'), __FILE__)).each { |file| load file }
