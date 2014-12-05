# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/mongo/version'

Gem::Specification.new do |spec|
  spec.name          = "rom-mongo"
  spec.version       = ROM::Mongo::VERSION.dup
  spec.authors       = ["Piotr Solnica"]
  spec.email         = ["piotr.solnica@gmail.com"]
  spec.summary       = %q{MongoDB support for Ruby Object Mapper}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "moped"
  spec.add_runtime_dependency "rom", "~> 0.4", ">= 0.4.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
