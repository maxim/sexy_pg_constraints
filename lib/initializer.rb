class SexyPgConstraintsRailtie < Rails::Railtie
  config.after_initialize do
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, SexyPgConstraints)
  end
end
