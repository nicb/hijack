require "hijack/version"

module Hijack
  LIBPATH = File.expand_path(File.join('..', 'hijack'), __FILE__)
  CONF_PATH = File.expand_path(File.join(['..'] * 2, 'config'), __FILE__)
  DEFAULT_CONFIG_FILE = File.join(CONF_PATH, 'configuration.rb')
  TMPDIR = File.expand_path(File.join(['..'] * 2, 'tmp'), __FILE__)
end

%w(
  helpers
  hijack_logger
  output_drivers
  configuration
  page
  page_loader
  website
).each { |f| require File.join(Hijack::LIBPATH, f) }
