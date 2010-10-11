class SexyPgConstraintsRailtie < Rails::Railtie
  initializer "sexy_pg_constraints.include", :after => :active_record do
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, SexyPgConstraints)
  end
end
