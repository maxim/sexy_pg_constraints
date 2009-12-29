module AssertProhibitsAllows
  def assert_prohibits(model, column, constraint, constraint_type = 'check')
    column = column.join('_') if column.respond_to?(:join)
    
    book = model.new
    yield(book)
    assert book.valid?
    error = assert_raise ActiveRecord::StatementInvalid do 
      book.save 
    end
    assert_match /PGError/, error.message
    assert_match /violates #{constraint_type} constraint/, error.message
    assert_match /"#{model.table_name}_#{column}_(#{Array(constraint).map {|c| c.to_s }.join('|')})"/, error.message if constraint_type == 'check'
  end
  
  def assert_allows(model)
    first_count = model.count
    book = model.new
    yield(book)
    assert book.valid?
    assert_nothing_raised do 
      book.save
    end
    assert_equal first_count + 1, model.count
  end
end

Test::Unit::TestCase.send(:include, AssertProhibitsAllows)