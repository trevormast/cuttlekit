# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuttlekit/version'

Gem::Specification.new do |spec|
  spec.name          = "cuttlekit"
  spec.version       = Cuttlekit::VERSION
  spec.authors       = ["trevormast"]
  spec.email         = ["trevormast@gmail.com"]

  spec.summary       = %q(Commit whole directories to GitHub!)
  spec.description   = %q(you'll really like this gem.)
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "octokit", "~> 4.1.1"
  spec.add_development_dependency "rspec"
end
