module Hijack
  module OutputDrivers
    module Ascii
      PATH = File.expand_path(File.join('..', 'ascii'), __FILE__)
    end
  end
end

%w(
  driver
).each { |f| require File.join(Hijack::OutputDrivers::Ascii::PATH, f) }
