# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: ansibler 0.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "ansibler"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Alistair A. Israel"]
  s.date = "2015-05-22"
  s.description = "ansibler is a Ruby gem that provides utility classes for modeling, reading and writing Ansible inventory and playbook files."
  s.email = "aisrael@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "ansibler.gemspec",
    "features/.nav",
    "features/README.md",
    "features/inventory/reading.feature",
    "features/inventory/writing.feature",
    "features/step_definitions/common_steps.rb",
    "features/support/env.rb",
    "lib/ansible/inventory.rb",
    "lib/ansibler.rb"
  ]
  s.homepage = "http://github.com/aisrael/ansibler"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9")
  s.rubygems_version = "2.4.6"
  s.summary = "Ruby gem for reading and writing Ansible files"
  s.test_files = ["features/README.md", "features/inventory/reading.feature", "features/inventory/writing.feature", "features/step_definitions/common_steps.rb", "features/support/env.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["= 4.2.1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<rspec>, ["~> 3.2"])
      s.add_development_dependency(%q<cucumber>, ["~> 2.0"])
      s.add_development_dependency(%q<aruba>, ["= 0.6.2"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<rubocop>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.2.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8.7"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, ["= 4.2.1"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<rspec>, ["~> 3.2"])
      s.add_dependency(%q<cucumber>, ["~> 2.0"])
      s.add_dependency(%q<aruba>, ["= 0.6.2"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<rubocop>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 4.2.0"])
      s.add_dependency(%q<yard>, ["~> 0.8.7"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["= 4.2.1"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<rspec>, ["~> 3.2"])
    s.add_dependency(%q<cucumber>, ["~> 2.0"])
    s.add_dependency(%q<aruba>, ["= 0.6.2"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<rubocop>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 4.2.0"])
    s.add_dependency(%q<yard>, ["~> 0.8.7"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
  end
end

