# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'query_filter/version'

Gem::Specification.new do |spec|
  spec.name          = 'query_filter'
  spec.version       = QueryFilter::VERSION
  spec.authors       = ['Igor Galeta', 'Igor Malinovskiy']
  spec.email         = ['igor.malinovskiy@netfix.xyz']

  spec.summary       = 'ActiveRecord query filter gem'
  spec.description   = 'This gem provides DSL to write custom complex filters for ActiveRecord models'
  spec.homepage      = 'https://github.com/psyipm/query_filter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'rb-fsevent', '0.9.8'
  spec.add_development_dependency 'activerecord', '>= 4.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'

  spec.add_dependency 'activesupport', '>= 4.0'
end
