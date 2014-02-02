# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dea/version"

Gem::Specification.new do |s|
  s.name          = "dea"
  s.version       = Dea::VERSION
  s.date          = "2014-02-01"
  s.authors       = ["Hwan-Joon Choi"]
  s.email         = ["hc5duke@gmail.com"]
  s.homepage      = "https://github.com/distill-inc/dea"

  s.summary       = "Distill Exchange API"
  s.description   = "Exchange proxy server API wrapper in ruby for Distill."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "json", "~> 1.7.7"
  s.add_dependency "typhoeus", "0.6.7"
  s.add_dependency "queryparams", "0.0.3"
  s.add_development_dependency "rspec", "~> 2.5"
  s.add_development_dependency "webmock", "~> 1.17"
end
