require "helpers"
require "constrainer"
require "deconstrainer"
require "constraints"

module SexyPgConstraints
  def constrain(*args)
    if block_given?
      yield SexyPgConstraints::Constrainer.new(args[0].to_s)
    else
      SexyPgConstraints::Constrainer::add_constraints(*args)
    end
  end

  def deconstrain(*args)
    if block_given?
      yield SexyPgConstraints::DeConstrainer.new(args[0])
    else
      SexyPgConstraints::DeConstrainer::drop_constraints(*args)
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, SexyPgConstraints)