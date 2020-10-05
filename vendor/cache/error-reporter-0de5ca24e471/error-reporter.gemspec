# -*- encoding: utf-8 -*-
# stub: error-reporter 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "error-reporter".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Babar Al-Amin".freeze]
  s.date = "2019-08-26"
  s.description = "Simple Error reporting for WellTravel internal apps".freeze
  s.email = ["babar.al-amin@welltravel.com".freeze]
  s.executables = ["console".freeze, "setup".freeze]
  s.files = [".editorconfig".freeze, ".gitignore".freeze, ".rspec".freeze, ".rubocop.yml".freeze, ".ruby-version".freeze, "Gemfile".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "circle.yml".freeze, "config.reek".freeze, "error-reporter.gemspec".freeze, "lib/error/reporter.rb".freeze, "lib/error_reporter.rb".freeze, "spec/error_reporter_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "https://github.com/wtag/error-reporter".freeze
  s.rubygems_version = "3.0.4".freeze
  s.summary = "Simple Error reporting for WellTravel internal apps".freeze
  s.test_files = ["spec/error_reporter_spec.rb".freeze, "spec/spec_helper.rb".freeze]

  s.installed_by_version = "3.0.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.13"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
  end
end
