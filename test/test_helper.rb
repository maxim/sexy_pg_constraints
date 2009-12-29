require 'rubygems'
require 'test/unit'
require 'active_record'
require 'postgresql_adapter'
require "sexy_pg_constraints"
require File.dirname(__FILE__) + '/support/models'

db_config_path = File.join(File.dirname(__FILE__), 'support', 'database.yml')
ActiveRecord::Base.establish_connection(YAML::load(open(db_config_path)))
