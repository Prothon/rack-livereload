# -*- encoding: utf-8 -*-
# $:.push File.expand_path("../lib", __FILE__)
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "rack/livereload/version"

Gem::Specification.new do |s|
  s.name        = "rack-livereload"
  s.version     = Rack::LiveReload::VERSION
  s.authors     = ["Andrew Raymer"]
  s.email       = ["andrewraymer@gmail.com"]
  s.homepage    = ""
  s.license     = "MIT"
  s.summary     = %q{Insert LiveReload into your app easily as Rack middleware}
  s.description = %q{Insert LiveReload into your app easily as Rack middleware}

  s.rubyforge_project = "rack-livereload"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "httparty"
  s.add_development_dependency "sinatra"
  s.add_development_dependency "shotgun"
  s.add_development_dependency "thin"
  s.add_development_dependency "rake"
  s.add_development_dependency "mocha"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-cucumber"
  s.add_development_dependency "guard-livereload"
  s.add_development_dependency "webmock"
  s.add_development_dependency "secure_headers"
  s.add_development_dependency "nokogiri", ("< 1.6" if RUBY_VERSION < "1.9") # Nokogiri >= 1.6 requires Ruby >= 1.9
  s.add_development_dependency 'appraisal', '~> 0.4'
  s.add_runtime_dependency "rack"
end
