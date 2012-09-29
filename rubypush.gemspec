# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubypush/version'

Gem::Specification.new do |gem|
  gem.name          = "rubypush"
  gem.version       = RubyPush::VERSION
  gem.authors       = ["Jon Klein"]
  gem.email         = ["jk@artificial.com"]
  gem.description   = %q{A Ruby implementation of the Push programming language}
  gem.summary       = %q{A Ruby implementation of the Push programming language}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
