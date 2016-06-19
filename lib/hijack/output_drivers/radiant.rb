module Hijack
  module OutputDrivers
    module Radiant
      PATH = File.expand_path(File.join('..', 'radiant'), __FILE__)
    end
  end
end

%w(
  extensions
  configuration
  base
  page
  page_part
  page_field
  page_methods
  page_attachment
  asset
  asset_type
  driver
).each { |f| require File.join(Hijack::OutputDrivers::Radiant::PATH, f) }
