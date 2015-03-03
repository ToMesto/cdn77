# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cdn77/version"

Gem::Specification.new do |spec|
  spec.name          = "cdn77"
  spec.version       = Cdn77::VERSION
  spec.authors       = ["Sergey Tsvetkov"]
  spec.email         = ["sergey.a.tsvetkov@gmail.com"]
  spec.summary       = %q{Wrapper for CDN77 API}
  spec.description   = %q{CDN77 API allows you to do a wide range of commands and tasks from an external script or server.}
  spec.homepage      = "https://github.com/ToMesto/cdn77"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "webmock", "~> 1.20"
end
