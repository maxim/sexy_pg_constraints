module SexyPgConstraints
  module Constraints
    module_function
    
    ##
    # Only allow listed values.
    #
    # Example: 
    #   constrain :books, :variation, :whitelist => %w(hardcover softcover)
    #
    def whitelist(column, options)
      "check (#{column} in (#{ options.collect{|v| "'#{v}'"}.join(',')  }))"
    end
  
    ## 
    # Prohibit listed values.
    #
    # Example: 
    #   constrain :books, :isbn, :blacklist => %w(invalid_isbn1 invalid_isbn2)
    #
    def blacklist(column, options)
      "check (#{column} not in (#{ options.collect{|v| "'#{v}'"}.join(',') }))"
    end
  
    ## 
    # The value must have at least 1 non-space character.
    #
    # Example:
    #   constrain :books, :title, :not_blank => true
    #
    def not_blank(column, options)
      "check ( length(trim(both from #{column})) > 0 )"
    end

    ## 
    # The numeric value must be within given range.
    #
    # Example:
    #   constrain :books, :year, :within => 1980..2008
    #   constrain :books, :year, :within => 1980...2009
    # (the two lines above do the same thing)
    #
    def within(column, options)
      "check (#{column} >= #{options.begin} and #{column} #{options.exclude_end? ? ' < ' : ' <= '} #{options.end})"
    end

    ## 
    # Check the length of strings/text to be within the range.
    #
    # Example:
    #   constrain :books, :author, :length_within => 4..50
    #
    def length_within(column, options)
      within("length(#{column})", options)
    end
    
    ## 
    # Allow only valid email format.
    #
    # Example:
    #   constrain :books, :author, :email => true
    #
    def email(column, options)
      "check (((#{column})::text ~ E'^([-a-z0-9]+)@([-a-z0-9]+[.]+[a-z]{2,4})$'::text))"
    end

    ## 
    # Allow only alphanumeric values.
    #
    # Example:
    #   constrain :books, :author, :alphanumeric => true
    #
    def alphanumeric(column, options)
      "check (((#{column})::text ~* '^[a-z0-9]+$'::text))"
    end
    
    ## 
    # Allow only positive values.
    #
    # Example:
    #   constrain :books, :quantity, :positive => true
    #
    def positive(column, options)
      "check (#{column} >= 0)"
    end
    
    ## 
    # Allow only odd values.
    #
    # Example:
    #   constrain :books, :quantity, :odd => true
    #
    def odd(column, options)
      "check (mod(#{column}, 2) != 0)"
    end

    ## 
    # Allow only even values.
    #
    # Example:
    #   constrain :books, :quantity, :even => true
    #
    def even(column, options)
      "check (mod(#{column}, 2) = 0)"
    end

    ## 
    # Make sure every entry in the column is unique.
    #
    # Example:
    #   constrain :books, :isbn, :unique => true
    #
    def unique(column, options)
      column = column.join(', ') if column.respond_to?(:join)
      "unique (#{column})"
    end
    
    ## 
    # Allow only text/strings of the exact length specified, no more, no less.
    #
    # Example:
    #   constrain :books, :hash, :exact_length => 32
    #
    def exact_length(column, options)
      "check ( length(trim(both from #{column})) = #{options} )"
    end
    
    ## 
    # Allow only values that match the regular expression.
    #
    # Example:
    #   constrain :orders, :visa, :format => /^([4]{1})([0-9]{12,15})$/
    #
    def format(column, options)
      "check (((#{column})::text #{options.casefold? ? '~*' : '~'}  E'#{options.source}'::text ))"
    end
    
    ## 
    # Add foreign key constraint.
    #
    # Example:
    #   constrain :books, :author_id, :reference => {:authors => :id, :on_delete => :cascade}
    #
    def reference(column, options)
      on_delete = options.delete(:on_delete)
      fk_table = options.keys.first
      fk_column = options[fk_table]
      
      on_delete = "on delete #{on_delete}" if on_delete
      
      "foreign key (#{column}) references #{fk_table} (#{fk_column}) #{on_delete}"
    end
  end
end