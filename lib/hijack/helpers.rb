require "hijack/version"

module Hijack
  module Helpers
    PATH = File.expand_path(File.join('..', 'helpers'), __FILE__)
  end
end

%w(
  uri
).each { |f| require File.join(Hijack::Helpers::PATH, f) }

