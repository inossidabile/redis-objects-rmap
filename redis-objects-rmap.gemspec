# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis/objects/rmap/version'

Gem::Specification.new do |gem|
  gem.name          = "redis-objects-rmap"
  gem.version       = Redis::Objects::Rmap::VERSION
  gem.authors       = ["Boris Staal"]
  gem.email         = ["boris@roundlake.ru"]
  gem.description   = %q{Adds fast-map to a AR model}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/inossidabile/redis-objects-rmap"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activesupport"
  gem.add_dependency "redis-objects"
end
