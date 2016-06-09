module Hijack
  module OutputDrivers
    module Radiant
      PATH = File.expand_path(File.join('..', 'radiant'), __FILE__)
    end
  end
end

%w(
  base
  page
  sqlite/driver
).each { |f| require File.join(Hijack::OutputDrivers::Radiant::PATH, f) }
