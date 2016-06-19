# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hijack/version'

Gem::Specification.new do |spec|
  spec.name          = "hijack"
  spec.version       = Hijack::VERSION
  spec.authors       = ["Nicola Bernardini"]
  spec.email         = ["nicb@sme-ccppd.org"]

  spec.summary       = %q{Software that hijacks websites to migrate them somewhere else}
  spec.description   = %q{Software that hijacks websites to migrate them somewhere else}
  spec.homepage      = 'https://github.com/nicb/hijack'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://github.com/nicb/hijack'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'activerecord', '~> 4.2.6'
  spec.add_dependency 'htmlentities'

  #
  # these are needed for paperclip functionalities in the Radiant driver
  #
  spec.add_dependency "acts_as_list", "0.1.4"
  spec.add_dependency "paperclip",    "~> 2.7.0"
  spec.add_dependency "uuidtools",    "~> 2.1.2"
  spec.add_dependency "cocaine",      "~> 0.3.2"

end
