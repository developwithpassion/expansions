# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib",__FILE__)
require "expansions/version"

Gem::Specification.new do |s|
  s.name        = "expansions"
  s.version     = Expansions::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license    = 'MIT'
  s.authors     = ["Develop With Passion®"]
  s.email       = ["open_source@developwithpassion.com"]
  s.homepage    = "http://www.developwithpassion.com"
  s.summary     = %q{Simple Expansion Automation Utility}
  s.description = %q{Automation utitlity that I use to support cross platform file maintenance}
  s.rubyforge_project = "expansions"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'configatron', '>= 4.1.0'
  s.add_runtime_dependency "mustache", '>= 0.99.5'
  s.add_runtime_dependency "arrayfu", '>= 1.0.0'
end
