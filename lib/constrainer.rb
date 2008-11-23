module SexyPgConstraints
  class Constrainer
    include SexyPgConstraints::Helpers
    
    def initialize(table)
      @table = table.to_s
    end

    def method_missing(column, constraints)
      self.class.add_constraints(@table, column.to_s, constraints)
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
            SexyPgConstraints::Constraints.send(type, column.to_s, options) + ';'
          
          execute sql
        end
      end
    end
  end
end