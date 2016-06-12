task :environment do
  DatabaseTasks.env = ENV['HIJACK_ENV'] || 'development'
end
