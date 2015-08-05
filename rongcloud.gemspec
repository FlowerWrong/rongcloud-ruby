# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rongcloud/version'

Gem::Specification.new do |spec|
  spec.name          = 'rongcloud'
  spec.version       = Rongcloud::VERSION
  spec.authors       = ['yang']
  spec.email         = ['sysuyangkang@gmail.com']

  spec.summary       = %q{RongCloud ruby sdk client.}
  spec.description   = %q{A ruby sdk client for RongCloud.}
  spec.homepage      = 'https://github.com/FlowerWrong/rongcloud-ruby'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.2'
  spec.add_dependency 'rest-client', '~> 1.6'
  spec.add_dependency 'logging', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
end
