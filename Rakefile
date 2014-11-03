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

require 'rake'

gemspec = eval(File.read(Dir['*.gemspec'].first))

task :default => :test
task :test => ['test:client']

desc 'Validate the gemspec'
task :gemspec do
  gemspec.validate
end

desc 'Build gem locally'
task :build => :gemspec do
  system "gem build #{gemspec.name}.gemspec"
  FileUtils.mkdir 'pkg' unless File.exists? 'pkg'
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", 'pkg'
end

# You may try using 'sudo' in case you get any write permission errors while running this task...
desc 'Install gem locally'
task :install => :build do
  system "gem install pkg/#{gemspec.name}-#{gemspec.version}.gem --no-ri --no-rdoc"
end

# You may try using 'sudo' in case you get any write permission errors while running this task...
desc 'Uninstall gem locally'
task :uninstall do
  system "gem uninstall #{gemspec.name}"
end

desc 'Clean automatically generated files'
task :clean do
  FileUtils.rm_rf 'pkg'
end

desc 'Check syntax'
task :syntax do
  Dir['**/*.rb'].each {|file|
    print "#{file}: "
    system "ruby -c #{file}"
  }
end

namespace :test do
  desc 'Run client tests'
  task :client do
    all = Dir['tests/**/*_test.rb']
    srv = Dir['tests/**/srv_*_test.rb']
    files = all.to_a - srv.to_a
    files.each {|fn|
      system "ruby #{fn}"
    }
  end

  desc 'Run server tests'
  task :server do
    files = Dir['tests/**/srv_*_test.rb']
    files.each {|fn|
      system "ruby #{fn}"
    }
  end
end

