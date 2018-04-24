# -*- encoding: utf-8 -*-

require File.expand_path("../lib/gemgate/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dan Peterson"]
  gem.email         = ["dpiddy@gmail.com"]
  gem.description   = %q{Host a private gem repository at S3}
  gem.summary       = %q{Host a private gem repository at S3}
  gem.homepage      = "https://github.com/dpiddy/gemgate"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "gemgate"
  gem.require_paths = ["lib"]
  gem.version       = Gemgate::VERSION

  gem.add_dependency "sinatra", "~> 1.4.6"
  gem.add_dependency "fog-aws", "~> 0.7.4"
  gem.add_dependency "mime-types", "~> 3.1"

  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"

  gem.required_ruby_version = '>= 2.4.4'

end
