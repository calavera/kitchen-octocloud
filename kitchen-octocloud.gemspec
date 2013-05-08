# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/driver/octocloud_version'

Gem::Specification.new do |spec|
  spec.name          = "kitchen-octocloud"
  spec.version       = Kitchen::Driver::OCTOCLOUD_VERSION
  spec.authors       = ["David Calavera"]
  spec.email         = ["david.calavera@gmail.com"]
  spec.description   = "Test Kitchen driver to use Octocloud"
  spec.summary       = "Run Chef integration tests on Octocloud"
  spec.homepage      = "https://github.com/calavera/kitchen-octocloud"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fog-octocloud"
  spec.add_dependency "test-kitchen"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
