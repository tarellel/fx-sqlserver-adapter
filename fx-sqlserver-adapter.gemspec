# frozen_string_literal: true
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fx/sqlserver_adapter/version'

Gem::Specification.new do |spec|
  spec.name          = 'fx-sqlserver-adapter'
  spec.version       = Fx::SqlserverAdapter::VERSION
  spec.authors       = ['Brandon Hicks']
  spec.email         = ['tarellel@gmail.com']
  spec.summary       = %q{SqlServer/MsSQL adapter for Fx gem}
  spec.description   = <<-DESCRIPTION
    Adds sqlserver adapter to Fx gem to enable database migrations and schema
    to work with functions and triggers on applications using
    sqlserver as database
  DESCRIPTION
  spec.homepage      = 'https://github.com/tarellel/fx-sqlserver-adapter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.5'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.3'
  spec.add_development_dependency 'tiny_tds', '>= 2.0'
  spec.add_development_dependency 'pry'

  spec.add_dependency 'activerecord', '>= 6.0.0'
  spec.add_dependency 'railties', '>= 6.0.0'
  spec.add_dependency 'fx', '~> 0.6.2'

  spec.required_ruby_version = '>= 2.7'
end
