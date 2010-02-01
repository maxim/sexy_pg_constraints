# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sexy_pg_constraints}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Maxim Chernyak"]
  s.date = %q{2010-02-01}
  s.description = %q{Use migrations and simple syntax to manage constraints in PostgreSQL DB.}
  s.email = %q{max@bitsonnet.com}
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "README.rdoc", "lib/constrainer.rb", "lib/constraints.rb", "lib/deconstrainer.rb", "lib/helpers.rb", "lib/sexy_pg_constraints.rb"]
  s.files = ["CHANGELOG.rdoc", "Manifest", "README.rdoc", "Rakefile", "init.rb", "lib/constrainer.rb", "lib/constraints.rb", "lib/deconstrainer.rb", "lib/helpers.rb", "lib/sexy_pg_constraints.rb", "sexy_pg_constraints.gemspec", "test/postgresql_adapter.rb", "test/sexy_pg_constraints_test.rb", "test/support/assert_prohibits_allows.rb", "test/support/database.yml", "test/support/database.yml.example", "test/support/models.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/maxim/sexy_pg_constraints}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Sexy_pg_constraints", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sexy_pg_constraints}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{If you're on PostgreSQL and see the importance of data-layer constraints - this gem/plugin is for you. It integrates constraints into PostgreSQL adapter so you can add/remove them in your migrations. You get two simple methods for adding/removing constraints, as well as a pack of pre-made constraints.}
  s.test_files = ["test/sexy_pg_constraints_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
