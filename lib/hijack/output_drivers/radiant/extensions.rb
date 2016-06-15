module Hijack
  module OutputDrivers
    module Radiant
      module Extensions
        PATH = File.expand_path(File.join('..', 'extensions'), __FILE__)
      end
    end
  end
end

%w(
  string
  nokogiri
).each { |f| require File.join(Hijack::OutputDrivers::Radiant::Extensions::PATH, f) }

