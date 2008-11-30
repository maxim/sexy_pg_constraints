module SexyPgConstraints
  class DeConstrainer
    include SexyPgConstraints::Helpers
  
    def initialize(table, columns = [])
      @table = table.to_s
      @columns = columns
    end
  
    def method_missing(column, *constraints)
      self.class.drop_constraints(@table, column.to_s, *constraints)
    end
    
    def [](*columns)
      @columns = columns.map{|c| c.to_s}
      self
    end
    
    def all(*constraints)
      self.class.drop_constraints(@table, @columns, *constraints)
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