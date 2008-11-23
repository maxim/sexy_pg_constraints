module SexyPgConstraints
  class DeConstrainer
    include SexyPgConstraints::Helpers
  
    def initialize(table)
      @table = table.to_s
    end
  
    def method_missing(column, *constraints)
      self.class.drop_constraints(@table, column.to_s, *constraints)
    end
  
    class << self
      def drop_constraints(table, column, *constraints)
        constraints.each do |type|
          execute "alter table #{table} drop constraint #{make_title(table, column, type)};"
        end
      end
    end
  end
end