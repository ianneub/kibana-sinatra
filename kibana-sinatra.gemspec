# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kibana/sinatra/version'

Gem::Specification.new do |spec|
  spec.name          = "kibana-sinatra"
  spec.version       = Kibana::Rails::VERSION
  spec.authors       = ["Ian Neubert"]
  spec.email         = ["ian@ianneubert.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = "http://github.com/ianneub/kibana-sinatra"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sinatra", "~> 1.4"
end
