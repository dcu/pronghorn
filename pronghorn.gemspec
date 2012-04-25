# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pronghorn/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "pronghorn"
  gem.version       = Pronghorn::VERSION

  gem.authors       = ["Guillermo Iguaran"]
  gem.email         = ["guilleiguaran@gmail.com"]
  gem.description   = %q{Minimal server for Rack apps based in EventMachine and http-parser}
  gem.summary       = %q{Minimal HTTP server for Rack apps}
  gem.homepage      = "http://guilleiguaran.github.com/pronghorn"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_dependency 'eventmachine'
  gem.add_dependency 'http_parser.rb'
  gem.add_dependency 'rack'
  gem.add_development_dependency 'minitest'
end
