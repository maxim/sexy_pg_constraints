require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('sexy_pg_constraints', '0.1.2') do |p|
  p.description     = "Use migrations and simple syntax to manage constraints in PostgreSQL DB."
  p.summary         = "If you're on PostgreSQL and see the importance of data-layer constraints - this gem/plugin is for you. It integrates constraints into PostgreSQL adapter so you can add/remove them in your migrations. You get two simple methods for adding/removing constraints, as well as a pack of pre-made constraints."
  p.url             = "http://github.com/maxim/sexy_pg_constraints"
  p.author          = "Maxim Chernyak"
  p.email           = "max@bitsonnet.com"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }