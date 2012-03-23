require 'rubygems'
require File.expand_path('../lib/smartling/version', __FILE__)

Gem::Specification.new {|gem|
  gem.name = 'smartling'
  gem.version = Smartling::VERSION

  gem.summary = 'Smartling SDK'
  gem.description = 'A Ruby library to utilize Smartling services'
  gem.authors = ['Pavel Ivashkov']
  gem.email = ['hi@smartling.com']
  gem.homepage = 'https://github.com/Smartling/smartling-ruby-sdk'
  gem.license = 'LICENSE'

  gem.require_path = 'lib'
  gem.files = Dir['README.md', 'LICENSE', '{lib}/**/*.rb', 'samples/**/*']
  gem.test_files = Dir['tests/**/*']

  gem.add_dependency 'multi_json', '~> 1.0'
  gem.add_dependency 'rest-client', '~> 1.6'
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.8.6'
}
