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
        available_constraints = SexyPgConstraints::Constraints.methods - Object.methods
        valid_constraints = constraints.reject { |k, v| !(available_constraints).include?(k.to_s) }
        invalid_constraints = constraints.keys - valid_constraints.keys
        
        if invalid_constraints.size > 0 
          raise "Invalid constraints specified: #{(invalid_constraints).join(',')}"
        end
        
        valid_constraints.each_pair do |type, options|
          sql = "alter table #{table} add constraint #{make_title(table, column, type)} " + 
            SexyPgConstraints::Constraints.send(type, column, options) + ';'
          
          execute sql
        end
      end
    end
  end
end