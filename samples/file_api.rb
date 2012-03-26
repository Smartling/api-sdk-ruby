#!/usr/bin/ruby
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
require 'smartling'

API_KEY = 'YOUR_APIKEY'
PROJECT_ID = 'YOUR_PROJECTID'

puts 'Smartling Ruby client ' + Smartling::VERSION


# Initialize client to sandbox
sl = Smartling::File.sandbox(:apiKey => API_KEY, :projectId => PROJECT_ID)

# Initialize client for production File API
#sl = Smartling::File.new(:apiKey => API_KEY, :projectId => PROJECT_ID)

# Upload YAML file
res = sl.upload('source_file.yaml', 'name.yaml', 'YAML')
p res

# Get list of uploaded files
res = sl.list()
p res

name = 'path/file_name.yaml'
lang = 'es-ES'

# Request translation status of the file
res = sl.status(name, :locale => lang)
p res

# Download translated file in specified language
data = sl.download(name, :locale => lang)
puts data

