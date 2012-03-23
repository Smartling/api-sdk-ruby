require 'rake'

gemspec = eval(File.read(Dir['*.gemspec'].first))

task :default => :test
task :test => ['test:all']

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

desc 'Install gem locally'
task :install => :build do
  system "gem install pkg/#{gemspec.name}-#{gemspec.version} --no-ri --no-rdoc"
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
  desc 'Run all tests'
  task :all do
    Dir['tests/**/*_test.rb'].each {|test_path|
      system "ruby #{test_path}"
    }
  end
end

