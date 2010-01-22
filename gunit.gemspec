# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{GUnit}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Greg Sterndale"]
  s.date = %q{2010-01-22}
  s.description = %q{GUnit is a fresh new XUnit Test implementation, poppin' a cap in the ass of TestUnit. Just playin'. TestUnit is our boy.}
  s.email = %q{gsterndale@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "gunit.gemspec",
     "lib/gunit.rb",
     "lib/gunit/assertions.rb",
     "lib/gunit/context.rb",
     "lib/gunit/exception_response.rb",
     "lib/gunit/exercise.rb",
     "lib/gunit/fail_response.rb",
     "lib/gunit/pass_response.rb",
     "lib/gunit/proc_extensions.rb",
     "lib/gunit/setup.rb",
     "lib/gunit/teardown.rb",
     "lib/gunit/test_case.rb",
     "lib/gunit/test_response.rb",
     "lib/gunit/test_runner.rb",
     "lib/gunit/test_suite.rb",
     "lib/gunit/to_do_response.rb",
     "lib/gunit/verification.rb",
     "test/integration/foo_test.rb",
     "test/test_helper.rb",
     "test/unit/assertions_test.rb",
     "test/unit/context_test.rb",
     "test/unit/fail_response_test.rb",
     "test/unit/proc_extensions_test.rb",
     "test/unit/setup_test.rb",
     "test/unit/teardown_test.rb",
     "test/unit/test_case_test.rb",
     "test/unit/test_runner_test.rb",
     "test/unit/test_suite_test.rb",
     "test/unit/verification_test.rb"
  ]
  s.homepage = %q{http://github.com/gsterndale/gunit}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{XUnit Test. Gangsta style.}
  s.test_files = [
    "test/integration/foo_test.rb",
     "test/test_helper.rb",
     "test/unit/assertions_test.rb",
     "test/unit/context_test.rb",
     "test/unit/fail_response_test.rb",
     "test/unit/proc_extensions_test.rb",
     "test/unit/setup_test.rb",
     "test/unit/teardown_test.rb",
     "test/unit/test_case_test.rb",
     "test/unit/test_runner_test.rb",
     "test/unit/test_suite_test.rb",
     "test/unit/verification_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

