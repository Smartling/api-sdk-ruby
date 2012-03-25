#!/usr/bin/ruby
require 'rubygems'
require 'smartling'

API_KEY = 'YOUR_APIKEY'
PROJECT_ID = 'YOUR_PROJECTID'

puts 'Smartling Ruby client ' + Smartling::VERSION

# Initialize File API client to sandbox
sl = Smartling::File.sandbox(:api_key => API_KEY, :project_id => PROJECT_ID)

# Initialize for production 
#sl = Smartling::File.new(:api_key => API_KEY, :project_id => PROJECT_ID)

# Upload YAML file
res = sl.upload('data.yaml', 'path/file_name.yaml', 'YAML')
puts res

# Get list of uploaded files
res = sl.list()
puts res

furi = 'path/file_name.yaml'
lang = 'es-ES'

# Request translation status of the file
res = sl.status(furi, :locale => lang)
puts res

# Download translated file in specified language
data = sl.download(furi, :locale => lang)
puts data

