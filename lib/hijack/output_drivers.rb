module Hijack
  module OutputDrivers
    PATH = File.expand_path(File.join('..', 'output_drivers'), __FILE__)
  end
end

%w(
  ascii
).each { |f| require File.join(Hijack::OutputDrivers::PATH, f) }
