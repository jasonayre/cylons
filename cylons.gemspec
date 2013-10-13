# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cylons/version'

Gem::Specification.new do |spec|
  spec.name          = "cylons"
  spec.version       = Cylons::VERSION
  spec.authors       = ["Jason Ayre"]
  spec.email         = ["jasonayre@gmail.com"]
  spec.description   = %q{Collective intelligence meets service oriented architecture. Allows your remote models to act like your local models, while defining simple conventions to build self aware and reusable services. Currently reliant upon Zookeeper.}
  spec.summary       = %q{Collectively intelligent (and simple), Service Oriented Architecture framework for Rails}
  spec.homepage      = "https://github.com/jasonayre/cylons"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "active_attr"
  spec.add_dependency "active_attr"
  spec.add_dependency "dcell", "0.15.0"
  spec.add_dependency "thor"
  spec.add_dependency "zk"
  spec.add_dependency 'pry'
  spec.add_dependency "will_paginate"
  spec.add_dependency "ransack"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "activerecord"
  # spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-pride"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "simplecov"
end
