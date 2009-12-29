module AssertProhibitsAllows
  def assert_prohibits(column, constraint, constraint_type = 'check')
    column = column.join('_') if column.respond_to?(:join)
    
    book = Book.new
    yield(book)
    assert book.valid?
    error = assert_raise ActiveRecord::StatementInvalid do 
      book.save 
    end
    assert_match /PGError/, error.message
    assert_match /violates #{constraint_type} constraint "books_#{column}_(#{Array(constraint).map {|c| c.to_s }.join('|')})"/, error.message
  end
  
  def assert_allows
    first_count = Book.count
    book = Book.new
    yield(book)
    assert book.valid?
    assert_nothing_raised do 
      book.save
    end
    assert_equal first_count + 1, Book.count
  end
end

Test::Unit::TestCase.send(:include, AssertProhibitsAllows)