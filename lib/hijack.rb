require "hijack/version"

module Hijack
  LIBPATH = File.expand_path(File.join('..', 'hijack'), __FILE__)
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
