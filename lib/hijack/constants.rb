module Hijack

  ROOT_DIR = File.expand_path(File.join(['..'] * 3), __FILE__)

  LIBPATH = File.join(ROOT_DIR, 'lib', 'hijack')
  CONF_PATH = File.join(ROOT_DIR, 'config')
  DEFAULT_CONFIG_FILE = File.join(CONF_PATH, 'configuration.rb')
  TMPDIR = File.join(ROOT_DIR, 'tmp')

  DATABASE_CONFIGURATION_FILE = File.join(CONF_PATH, 'databases.yml')
  DATABASE_DIR = File.join(ROOT_DIR, 'db')

end
