#
# rake tasks for the database
#
require 'active_record'
require 'active_record/tasks/sqlite_database_tasks'

include ActiveRecord::Tasks

require_relative File.join(['..'] * 2, 'lib', 'hijack', 'constants')

DatabaseTasks.root = Hijack::ROOT_DIR 
DatabaseTasks.database_configuration = YAML.load_file(Hijack::DATABASE_CONFIGURATION_FILE)
DatabaseTasks.db_dir = Hijack::DATABASE_DIR

ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
ActiveRecord::Base.schema_format = :ruby

task :environment do
  DatabaseTasks.env = ENV['HIJACK_ENV'] || 'development'
end

namespace :db do

  desc 'create current database'
  task create: [ :environment ] do
    DatabaseTasks.create_current(DatabaseTasks.env)
  end

  desc 'create all databases'
  task 'create:all' do
    DatabaseTasks.create_all
  end

  desc 'drop current database'
  task drop: [ :environment ] do
    DatabaseTasks.drop_current(DatabaseTasks.env)
  end

  desc 'drop all databases'
  task 'drop:all' do
    DatabaseTasks.drop_all
  end

  desc 'load schema into current database'
  task load_schema: [ :environment ] do
    DatabaseTasks.load_schema_current
  end

  desc 'load the database seeds'
  task seed: [ :environment ] do
    # DatabaseTasks.load_seed
  end

  desc 'reset the database completely'
  task reset: [ :environment, :drop, :create, :load_schema, :seed ]

  desc 'rebuild database from scratch'
  task rebuild: [ :reset ]

end
