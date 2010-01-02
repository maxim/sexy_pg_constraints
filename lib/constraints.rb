module SexyPgConstraints
  module Constraints
    module_function
    
    ##
    # Only allow listed values.
    #
    # Example: 
    #   constrain :books, :variation, :whitelist => %w(hardcover softcover)
    #
    def whitelist(table, column, options)
      "check (#{table}.#{column} in (#{ options.collect{|v| "'#{v}'"}.join(',')  }))"
    end
  
    ## 
    # Prohibit listed values.
    #
    # Example: 
    #   constrain :books, :isbn, :blacklist => %w(invalid_isbn1 invalid_isbn2)
    #
    def blacklist(table, column, options)
      "check (#{table}.#{column} not in (#{ options.collect{|v| "'#{v}'"}.join(',') }))"
    end
  
    ## 
    # The value must have at least 1 non-space character.
    #
    # Example:
    #   constrain :books, :title, :not_blank => true
    #
    def not_blank(table, column, options)
      "check ( length(trim(both from #{table}.#{column})) > 0 )"
    end

    ## 
    # The numeric value must be within given range.
    #
    # Example:
    #   constrain :books, :year, :within => 1980..2008
    #   constrain :books, :year, :within => 1980...2009
    # (the two lines above do the same thing)
    #
    def within(table, column, options)
      column_ref = column.to_s.include?('.') ? column : "#{table}.#{column}"
      "check (#{column_ref} >= #{options.begin} and #{column_ref} #{options.exclude_end? ? ' < ' : ' <= '} #{options.end})"
    end

    ## 
    # Check the length of strings/text to be within the range.
    #
    # Example:
    #   constrain :books, :author, :length_within => 4..50
    #
    def length_within(table, column, options)
      within(table, "length(#{table}.#{column})", options)
    end
    
    ## 
    # Allow only valid email format.
    #
    # Example:
    #   constrain :books, :author, :email => true
    #
    def email(table, column, options)
      "check (((#{table}.#{column})::text ~ E'^([-a-z0-9]+)@([-a-z0-9]+[.]+[a-z]{2,4})$'::text))"
    end

    ## 
    # Allow only alphanumeric values.
    #
    # Example:
    #   constrain :books, :author, :alphanumeric => true
    #
    def alphanumeric(table, column, options)
      "check (((#{table}.#{column})::text ~* '^[a-z0-9]+$'::text))"
    end
    
    ## 
    # Allow only positive values.
    #
    # Example:
    #   constrain :books, :quantity, :positive => true
    #
    def positive(table, column, options)
      "check (#{table}.#{column} >= 0)"
    end
    
    ## 
    # Allow only odd values.
    #
    # Example:
    #   constrain :books, :quantity, :odd => true
    #
    def odd(table, column, options)
      "check (mod(#{table}.#{column}, 2) != 0)"
    end

    ## 
    # Allow only even values.
    #
    # Example:
    #   constrain :books, :quantity, :even => true
    #
    def even(table, column, options)
      "check (mod(#{table}.#{column}, 2) = 0)"
    end

    ## 
    # Make sure every entry in the column is unique.
    #
    # Example:
    #   constrain :books, :isbn, :unique => true
    #
    def unique(table, column, options)
      column = Array(column).join(', ')
      "unique (#{column})"
    end
    
    ## 
    # Allow only text/strings of the exact length specified, no more, no less.
    #
    # Example:
    #   constrain :books, :hash, :exact_length => 32
    #
    def exact_length(table, column, options)
      "check ( length(trim(both from #{table}.#{column})) = #{options} )"
    end
    
    ## 
    # Allow only values that match the regular expression.
    #
    # Example:
    #   constrain :orders, :visa, :format => /^([4]{1})([0-9]{12,15})$/
    #
    def format(table, column, options)
      "check (((#{table}.#{column})::text #{options.casefold? ? '~*' : '~'}  E'#{options.source}'::text ))"
    end
    
    ## 
    # Add foreign key constraint.
    #
    # Example:
    #   constrain :books, :author_id, :reference => {:authors => :id, :on_delete => :cascade}
    #
    def reference(table, column, options)
      on_delete = options.delete(:on_delete)
      fk_table = options.keys.first
      fk_column = options[fk_table]
      
      on_delete = "on delete #{on_delete}" if on_delete
      
      "foreign key (#{column}) references #{fk_table} (#{fk_column}) #{on_delete}"
    end
  end
end