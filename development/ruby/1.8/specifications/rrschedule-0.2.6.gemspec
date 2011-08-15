# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rrschedule}
  s.version = "0.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["flamontagne"]
  s.date = %q{2011-02-24}
  s.description = %q{This gem automate the process of creating a round-robin sport schedule.}
  s.email = %q{flamontagne@azanka.ca}
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.files = [".document", ".gitignore", "LICENSE", "README.markdown", "Rakefile", "VERSION", "branches_info.markdown", "lib/rrschedule.rb", "test/helper.rb", "test/test_rrschedule.rb"]
  s.homepage = %q{http://flamontagne.github.com/rrschedule}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Round-Robin schedule generator}
  s.test_files = ["test/helper.rb", "test/test_rrschedule.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end
