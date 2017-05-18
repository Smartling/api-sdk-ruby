# Copyright 2012 Smartling, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rubygems'
require File.expand_path('../lib/smartling/version', __FILE__)

Gem::Specification.new {|gem|
  gem.name = 'smartling'
  gem.version = Smartling::VERSION

  gem.summary = 'Smartling SDK'
  gem.description = 'A Ruby library to utilize Smartling services'
  gem.authors = ['Emilien Huet']
  gem.email = ['hi@smartling.com']
  gem.homepage = 'http://docs.smartling.com'
  gem.license = 'LICENSE'

  gem.require_path = 'lib'
  gem.files = Dir['README.md', 'LICENSE', '{lib}/**/*.rb', 'samples/**/*']
  gem.test_files = Dir['tests/**/*'] - ['tests/config']

  gem.add_runtime_dependency 'oj', '~> 3.0'
  gem.add_runtime_dependency 'multi_json', '~> 1.0'
  gem.add_runtime_dependency 'rest-client', '~> 2.0'

  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 2.1'
}
