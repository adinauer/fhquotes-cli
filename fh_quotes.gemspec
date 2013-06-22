# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fh_quotes/version'

Gem::Specification.new do |spec|
  spec.name          = "fh_quotes"
  spec.version       = FhQuotes::VERSION
  spec.authors       = ["Alexander Dinauer"]
  spec.email         = ["alexander@dinauer.at"]
  spec.description   = %q{FhQuotes REST Client}
  spec.summary       = %q{Add new stocks, quotes and list existing ones.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
