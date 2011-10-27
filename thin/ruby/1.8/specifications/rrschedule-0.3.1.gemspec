# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rrschedule"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["flamontagne"]
  s.date = "2011-10-02"
  s.description = "This gem automate the process of creating a round-robin sport schedule."
  s.email = "flamontagne@azanka.ca"
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.files = ["LICENSE", "README.markdown"]
  s.homepage = "http://flamontagne.github.com/rrschedule"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Round-Robin schedule generator"

  if s.respond_to? :specification_version then
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
