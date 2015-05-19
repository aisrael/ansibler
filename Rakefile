# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'ansibler'
  gem.homepage = 'http://github.com/aisrael/ansibler'
  gem.license = 'MIT'
  gem.summary = 'Ruby gem for reading and writing Ansible files'
  gem.description = 'ansibler is a Ruby gem that provides utility classes for modeling, reading and writing Ansible inventory and playbook files.'
  gem.email = 'aisrael@gmail.com'
  gem.authors = ['Alistair A. Israel']

  # dependencies defined in Gemfile

  gem.files             = `git ls-files`.split("\n").delete_if {|f| f.start_with?('.')}
  gem.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
end
Jeweler::RubygemsDotOrgTasks.new

require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = %w(features/*.features --format pretty)
end

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new do |t|
end
