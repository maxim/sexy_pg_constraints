require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('sexy_pg_constraints', '0.1.2') do |p|
  p.description     = "Use migrations and simple syntax to manage constraints in PostgreSQL DB."
  p.url             = "http://github.com/maxim/sexy_pg_constraints"
  p.author          = "Maxim Chernyak"
  p.email           = "max@bitsonnet.com"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }