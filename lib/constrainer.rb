module SexyPgConstraints
  class Constrainer
    include SexyPgConstraints::Helpers
    
    def initialize(table, columns = [])
      @table = table.to_s
      @columns = columns
    end

    def method_missing(column, constraints)
      self.class.add_constraints(@table, column.to_s, constraints)
    end
    
    def [](*columns)
      @columns = columns.map{|c| c.to_s}
      self
    end
    
    def all(constraints)
      self.class.add_constraints(@table, @columns, constraints)
    end
    
    class << self
      def add_constraints(table, column, constraints)
        constraints.each_pair do |type, options|
          sql = "alter table #{table} add constraint #{make_title(table, column, type)} " + 
            SexyPgConstraints::Constraints.send(type, column, options) + ';'
          
          execute sql
        end
      end
    end
  end
end