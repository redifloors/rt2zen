# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rt2zen/version'

Gem::Specification.new do |spec|
  spec.name          = "RT2Zen"
  spec.version       = RT2Zen::VERSION
  spec.authors       = ["Donovan C. Young"]
  spec.email         = ["dyoung@redifloors.com"]
  spec.summary       = "Converts RT:Request Tracker helpdesk to Zendesk"
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'zendesk_api', '~> 1.3'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
