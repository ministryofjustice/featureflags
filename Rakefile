# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "featureflags"
  gem.homepage = "http://github.com/aldavidson/featureflags"
  gem.license = "MIT"
  gem.summary = %Q{Simple ENV-based implementation of Feature Flags}
  gem.description = <<-END
Simple implementation of the 'Feature Flags' pattern as a Ruby gem.
Allows you to set defaults in a Hash of the form:

  ```{ feature_name_1: true, feature_name_2: false, feature_with_variations: 'A' }```

and override them with correspondingly-named environment variables. 
In the example above, you could enable the feature 'feature_name_2' with the environment variable 'FEATURE_NAME_2'.

END
  gem.email = "apdavidson@gmail.com"
  gem.authors = ["Al Davidson"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "featureflags #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
