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

def print_msg(msg)
  puts
  puts msg
end

API_KEY = 'YOUR_API_KEY' # change this value to use "Smartling API key" found on the Project Settings -> API page in dashboard
PROJECT_ID = 'YOUR_PROJECT_ID' # change this value to use "Project Id" found on the Project Settings -> API page in dashboard

print_msg "Smartling Ruby client #{Smartling::VERSION}"

# Initialize client to use File API on Sandbox
sl = Smartling::File.sandbox(:apiKey => API_KEY, :projectId => PROJECT_ID)

# Initialize client to use File API on Production
#sl = Smartling::File.new(:apiKey => API_KEY, :projectId => PROJECT_ID)

# Basic usage

file = 'data.yaml' # your data file
file_uri = 'my_files/data.yaml' # unique identifier given to the uploaded file
file_type = 'YAML' # file type

print_msg "Uploading file '#{file}' using file URI '#{file_uri}' and file type '#{file_type}'..."
res = sl.upload(file, file_uri, file_type)
p res

print_msg 'Listing all project files...'
res = sl.list
p res

lang = 'es-ES' # any language that exists in your project

print_msg "Getting status for file URI '#{file_uri}' and language '#{lang}'..."
res = sl.status(file_uri, :locale => lang)
p res

print_msg "Downloading translations for file URI '#{file_uri}' and language '#{lang}'..."
data = sl.download(file_uri, :locale => lang)
puts data

new_file_uri = 'my_files/new_data.yaml' # new uri to uniquely identify the previously uploaded file

print_msg "Renaming file from '#{file_uri}' to '#{new_file_uri}'..."
sl.rename(file_uri, new_file_uri)

print_msg "Deleting file '#{new_file_uri}'..."
sl.delete(new_file_uri)

# Extended parameters

print_msg 'Uploading file with callback URL provided...'
res = sl.upload(file, 'name.yaml', 'YAML', :callbackUrl => 'http://yourdomain.com/someservice')
p res

print_msg 'Uploading file with approved flag provided...'
res = sl.upload(file, 'name.yaml', 'YAML', :approved => true)
p res

print_msg 'Listing files using URI mask filter...'
res = sl.list(:uriMask => '%.yaml')
p res

print_msg 'Listing files using file type filter...'
res = sl.list(:fileTypes => ['yaml', 'ios'])
p res

print_msg 'Listing files ordered by attributes...'
res = sl.list(:orderBy => ['fileUri', 'wordCount_desc'])
p res

print_msg 'Listing paginated files...'
page, size = 2, 10
res = sl.list(:offset => (page - 1) * size, :limit => size)
p res

print_msg 'Listing files uploaded after a certain date...'
res = sl.list(:lastUploadedAfter => Time.utc(2012, 04, 05))
p res

print_msg 'Listing files uploaded between a date range...'
res = sl.list(:lastUploadedAfter => Time.utc(2012, 04, 01), :lastUploadedBefore => Time.utc(2012, 05, 01))
p res

print_msg 'Listing files using translation status...'
res = sl.list(:conditions => ['haveAllTranslated', 'haveAtLeastOneUnapproved'])
p res

print_msg 'Listing files while combining multiple parameters...'
res = sl.list(:fileTypes => 'yaml', :orderBy => 'fileUri', :offset => 20, :limit => 10)
p res
