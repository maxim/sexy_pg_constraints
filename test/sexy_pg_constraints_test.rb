require File.dirname(__FILE__) + '/test_helper.rb'

class SexyPgConstraintsTest < Test::Unit::TestCase
  def setup
    CreateBooks.up
    CreateAuthors.up
  end

  def teardown
    CreateBooks.down
    CreateAuthors.down
  end

  def test_should_create_book
    Book.create
    assert_equal 1, Book.count
  end

  def test_whitelist
    ActiveRecord::Migration.constrain :books, :author, :whitelist => %w(whitelisted1 whitelisted2 whitelisted3)

    assert_prohibits Book, :author, :whitelist do |book|
      book.author = 'not_whitelisted'
    end

    assert_allows Book do |book|
      book.author = 'whitelisted2'
    end

    ActiveRecord::Migration.deconstrain :books, :author, :whitelist

    assert_allows Book do |book|
      book.author = 'not_whitelisted'
    end
  end

  def test_whitelist_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :whitelist => %w(whitelisted1 whitelisted2 whitelisted3)

    assert_prohibits Book, :as, :whitelist do |book|
      book.as = 'not_whitelisted'
    end

    assert_allows Book do |book|
      book.as = 'whitelisted2'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :whitelist

    assert_allows Book do |book|
      book.as = 'not_whitelisted'
    end
  end

  def test_blacklist
    ActiveRecord::Migration.constrain :books, :author, :blacklist => %w(blacklisted1 blacklisted2 blacklisted3)

    assert_prohibits Book, :author, :blacklist do |book|
      book.author = 'blacklisted2'
    end

    assert_allows Book do |book|
      book.author = 'not_blacklisted'
    end

    ActiveRecord::Migration.deconstrain :books, :author, :blacklist

    assert_allows Book do |book|
      book.author = 'blacklisted2'
    end
  end

  def test_blacklist_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :blacklist => %w(blacklisted1 blacklisted2 blacklisted3)

    assert_prohibits Book, :as, :blacklist do |book|
      book.as = 'blacklisted2'
    end

    assert_allows Book do |book|
      book.as = 'not_blacklisted'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :blacklist

    assert_allows Book do |book|
      book.as = 'blacklisted2'
    end
  end

  def test_not_blank
    ActiveRecord::Migration.constrain :books, :author, :not_blank => true

    assert_prohibits Book, :author, :not_blank do |book|
      book.author = ' '
    end

    assert_allows Book do |book|
      book.author = 'foo'
    end

    ActiveRecord::Migration.deconstrain :books, :author, :not_blank

    assert_allows Book do |book|
      book.author = ' '
    end
  end

  def test_not_blank_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :not_blank => true

    assert_prohibits Book, :as, :not_blank do |book|
      book.as = ' '
    end

    assert_allows Book do |book|
      book.as = 'foo'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :not_blank

    assert_allows Book do |book|
      book.as = ' '
    end
  end

  def test_within_inclusive
    ActiveRecord::Migration.constrain :books, :quantity, :within => 5..11

    assert_prohibits Book, :quantity, :within do |book|
      book.quantity = 12
    end

    assert_prohibits Book, :quantity, :within do |book|
      book.quantity = 4
    end

    assert_allows Book do |book|
      book.quantity = 7
    end

    ActiveRecord::Migration.deconstrain :books, :quantity, :within

    assert_allows Book do |book|
      book.quantity = 12
    end
  end

  def test_within_inclusive_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :from, :within => 5..11

    assert_prohibits Book, :from, :within do |book|
      book.from = 12
    end

    assert_prohibits Book, :from, :within do |book|
      book.from = 4
    end

    assert_allows Book do |book|
      book.from = 7
    end

    ActiveRecord::Migration.deconstrain :books, :from, :within

    assert_allows Book do |book|
      book.from = 12
    end
  end

  def test_within_non_inclusive
    ActiveRecord::Migration.constrain :books, :quantity, :within => 5...11

    assert_prohibits Book, :quantity, :within do |book|
      book.quantity = 11
    end

    assert_prohibits Book, :quantity, :within do |book|
      book.quantity = 4
    end

    assert_allows Book do |book|
      book.quantity = 10
    end

    ActiveRecord::Migration.deconstrain :books, :quantity, :within

    assert_allows Book do |book|
      book.quantity = 11
    end
  end

  def test_within_non_inclusive_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :from, :within => 5...11

    assert_prohibits Book, :from, :within do |book|
      book.from = 11
    end

    assert_prohibits Book, :from, :within do |book|
      book.from = 4
    end

    assert_allows Book do |book|
      book.from = 10
    end

    ActiveRecord::Migration.deconstrain :books, :from, :within

    assert_allows Book do |book|
      book.from = 11
    end
  end

  def test_length_within_inclusive
    ActiveRecord::Migration.constrain :books, :title, :length_within => 5..11

    assert_prohibits Book, :title, :length_within do |book|
      book.title = 'abcdefghijkl'
    end

    assert_prohibits Book, :title, :length_within do |book|
      book.title = 'abcd'
    end

    assert_allows Book do |book|
      book.title = 'abcdefg'
    end

    ActiveRecord::Migration.deconstrain :books, :title, :length_within

    assert_allows Book do |book|
      book.title = 'abcdefghijkl'
    end
  end

  def test_length_within_inclusive_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :length_within => 5..11

    assert_prohibits Book, :as, :length_within do |book|
      book.as = 'abcdefghijkl'
    end

    assert_prohibits Book, :as, :length_within do |book|
      book.as = 'abcd'
    end

    assert_allows Book do |book|
      book.as = 'abcdefg'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :length_within

    assert_allows Book do |book|
      book.as = 'abcdefghijkl'
    end
  end

  def test_length_within_non_inclusive
    ActiveRecord::Migration.constrain :books, :title, :length_within => 5...11

    assert_prohibits Book, :title, :length_within do |book|
      book.title = 'abcdefghijk'
    end

    assert_prohibits Book, :title, :length_within do |book|
      book.title = 'abcd'
    end

    assert_allows Book do |book|
      book.title = 'abcdefg'
    end

    ActiveRecord::Migration.deconstrain :books, :title, :length_within

    assert_allows Book do |book|
      book.title = 'abcdefghijk'
    end
  end

  def test_length_within_non_inclusive_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :length_within => 5...11

    assert_prohibits Book, :as, :length_within do |book|
      book.as = 'abcdefghijk'
    end

    assert_prohibits Book, :as, :length_within do |book|
      book.as = 'abcd'
    end

    assert_allows Book do |book|
      book.as = 'abcdefg'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :length_within

    assert_allows Book do |book|
      book.as = 'abcdefghijk'
    end
  end

  def test_email
    ActiveRecord::Migration.constrain :books, :author, :email => true

    assert_prohibits Book, :author, :email do |book|
      book.author = 'blah@example'
    end

    assert_allows Book do |book|
      book.author = 'blah@example.com'
    end

    ActiveRecord::Migration.deconstrain :books, :author, :email

    assert_allows Book do |book|
      book.author = 'blah@example'
    end
  end

  def test_email_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :email => true

    assert_prohibits Book, :as, :email do |book|
      book.as = 'blah@example'
    end

    assert_allows Book do |book|
      book.as = 'blah@example.com'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :email

    assert_allows Book do |book|
      book.as = 'blah@example'
    end
  end

  def test_alphanumeric
    ActiveRecord::Migration.constrain :books, :title, :alphanumeric => true

    assert_prohibits Book, :title, :alphanumeric do |book|
      book.title = 'asdf@asdf'
    end

    assert_allows Book do |book|
      book.title = 'asdf'
    end

    ActiveRecord::Migration.deconstrain :books, :title, :alphanumeric

    assert_allows Book do |book|
      book.title = 'asdf@asdf'
    end
  end

  def test_alphanumeric_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :alphanumeric => true

    assert_prohibits Book, :as, :alphanumeric do |book|
      book.as = 'asdf@asdf'
    end

    assert_allows Book do |book|
      book.as = 'asdf'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :alphanumeric

    assert_allows Book do |book|
      book.as = 'asdf@asdf'
    end
  end

  def test_positive
    ActiveRecord::Migration.constrain :books, :quantity, :positive => true

    assert_prohibits Book, :quantity, :positive do |book|
      book.quantity = -1
    end

    assert_allows Book do |book|
      book.quantity = 0
    end

    assert_allows Book do |book|
      book.quantity = 1
    end

    ActiveRecord::Migration.deconstrain :books, :quantity, :positive

    assert_allows Book do |book|
      book.quantity = -1
    end
  end

  def test_positive_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :from, :positive => true

    assert_prohibits Book, :from, :positive do |book|
      book.from = -1
    end

    assert_allows Book do |book|
      book.from = 0
    end

    assert_allows Book do |book|
      book.from = 1
    end

    ActiveRecord::Migration.deconstrain :books, :from, :positive

    assert_allows Book do |book|
      book.from = -1
    end
  end

  def test_odd
    ActiveRecord::Migration.constrain :books, :quantity, :odd => true

    assert_prohibits Book, :quantity, :odd do |book|
      book.quantity = 2
    end

    assert_allows Book do |book|
      book.quantity = 1
    end

    ActiveRecord::Migration.deconstrain :books, :quantity, :odd

    assert_allows Book do |book|
      book.quantity = 2
    end
  end

  def test_odd_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :from, :odd => true

    assert_prohibits Book, :from, :odd do |book|
      book.from = 2
    end

    assert_allows Book do |book|
      book.from = 1
    end

    ActiveRecord::Migration.deconstrain :books, :from, :odd

    assert_allows Book do |book|
      book.from = 2
    end
  end

  def test_even
    ActiveRecord::Migration.constrain :books, :quantity, :even => true

    assert_prohibits Book, :quantity, :even do |book|
      book.quantity = 1
    end

    assert_allows Book do |book|
      book.quantity = 2
    end

    ActiveRecord::Migration.deconstrain :books, :quantity, :even

    assert_allows Book do |book|
      book.quantity = 1
    end
  end

  def test_even_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :from, :even => true

    assert_prohibits Book, :from, :even do |book|
      book.from = 1
    end

    assert_allows Book do |book|
      book.from = 2
    end

    ActiveRecord::Migration.deconstrain :books, :from, :even

    assert_allows Book do |book|
      book.from = 1
    end
  end

  def test_unique
    ActiveRecord::Migration.constrain :books, :isbn, :unique => true

    assert_allows Book do |book|
      book.isbn = 'foo'
    end

    assert_prohibits Book, :isbn, :unique, 'unique' do |book|
      book.isbn = 'foo'
    end

    ActiveRecord::Migration.deconstrain :books, :isbn, :unique

    assert_allows Book do |book|
      book.isbn = 'foo'
    end
  end

  def test_unique_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :unique => true

    assert_allows Book do |book|
      book.as = 'foo'
    end

    assert_prohibits Book, :as, :unique, 'unique' do |book|
      book.as = 'foo'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :unique

    assert_allows Book do |book|
      book.as = 'foo'
    end
  end

  def test_exact_length
    ActiveRecord::Migration.constrain :books, :isbn, :exact_length => 5

    assert_prohibits Book, :isbn, :exact_length do |book|
      book.isbn = '123456'
    end

    assert_prohibits Book, :isbn, :exact_length do |book|
      book.isbn = '1234'
    end

    assert_allows Book do |book|
      book.isbn = '12345'
    end

    ActiveRecord::Migration.deconstrain :books, :isbn, :exact_length

    assert_allows Book do |book|
      book.isbn = '123456'
    end
  end

  def test_exact_length_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :exact_length => 5

    assert_prohibits Book, :as, :exact_length do |book|
      book.as = '123456'
    end

    assert_prohibits Book, :as, :exact_length do |book|
      book.as = '1234'
    end

    assert_allows Book do |book|
      book.as = '12345'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :exact_length

    assert_allows Book do |book|
      book.as = '123456'
    end
  end

  def test_format_case_insensitive
    ActiveRecord::Migration.constrain :books, :title, :format => /^[a-z]+$/i

    assert_prohibits Book, :title, :format do |book|
      book.title = 'abc3'
    end

    assert_prohibits Book, :title, :format do |book|
      book.title = ''
    end

    assert_allows Book do |book|
      book.title = 'abc'
    end

    assert_allows Book do |book|
      book.title = 'ABc'
    end

    ActiveRecord::Migration.deconstrain :books, :title, :format

    assert_allows Book do |book|
      book.title = 'abc3'
    end
  end

  def test_format_case_insensitive_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :format => /^[a-z]+$/i

    assert_prohibits Book, :as, :format do |book|
      book.as = 'abc3'
    end

    assert_prohibits Book, :as, :format do |book|
      book.as = ''
    end

    assert_allows Book do |book|
      book.as = 'abc'
    end

    assert_allows Book do |book|
      book.as = 'ABc'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :format

    assert_allows Book do |book|
      book.as = 'abc3'
    end
  end

  def test_format_case_sensitive
    ActiveRecord::Migration.constrain :books, :title, :format => /^[a-z]+$/

    assert_prohibits Book, :title, :format do |book|
      book.title = 'aBc'
    end

    assert_allows Book do |book|
      book.title = 'abc'
    end

    ActiveRecord::Migration.deconstrain :books, :title, :format

    assert_allows Book do |book|
      book.title = 'aBc'
    end
  end

  def test_format_case_sensitive_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :as, :format => /^[a-z]+$/

    assert_prohibits Book, :as, :format do |book|
      book.as = 'aBc'
    end

    assert_allows Book do |book|
      book.as = 'abc'
    end

    ActiveRecord::Migration.deconstrain :books, :as, :format

    assert_allows Book do |book|
      book.as = 'aBc'
    end
  end

  def test_reference
    ActiveRecord::Migration.constrain :books, :author_id, :reference => {:authors => :id}

    assert_prohibits Book, :author_id, :reference, 'foreign key' do |book|
      book.author_id = 1
    end

    author = Author.new
    author.name = "Mark Twain"
    author.bio = "American writer"
    assert author.save

    assert_equal 1, author.id

    assert_allows Book do |book|
      book.author_id = 1
    end

    ActiveRecord::Migration.deconstrain :books, :author_id, :reference

    assert_allows Book do |book|
      book.author_id = 2
    end
  end

  def test_reference_on_a_column_whose_name_is_a_sql_keyword
    ActiveRecord::Migration.constrain :books, :from, :reference => {:authors => :id}

    assert_prohibits Book, :from, :reference, 'foreign key' do |book|
      book.from = 1
    end

    author = Author.new
    author.name = "Mark Twain"
    author.bio = "American writer"
    assert author.save

    assert_equal 1, author.id

    assert_allows Book do |book|
      book.from = 1
    end

    ActiveRecord::Migration.deconstrain :books, :from, :reference

    assert_allows Book do |book|
      book.from = 2
    end
  end

  def test_reference_with_on_delete
    ActiveRecord::Migration.constrain :books, :author_id, :reference => {:authors => :id, :on_delete => :cascade}

    author = Author.new
    author.name = "Mark Twain"
    author.bio = "American writer"
    assert author.save

    assert_equal 1, Author.count

    assert_allows Book do |book|
      book.title = "The Adventures of Tom Sawyer"
      book.author_id = 1
    end

    assert_allows Book do |book|
      book.title = "The Adventures of Huckleberry Finn"
      book.author_id = 1
    end

    author.destroy

    assert_equal 0, Author.count
    assert_equal 0, Book.count
  end

  def test_block_syntax
    ActiveRecord::Migration.constrain :books do |t|
      t.title :not_blank => true
      t.isbn :exact_length => 15
      t.author :alphanumeric => true
    end

    assert_prohibits Book, :title, :not_blank do |book|
      book.title = '  '
    end

    assert_prohibits Book, :isbn, :exact_length do |book|
      book.isbn = 'asdf'
    end

    assert_prohibits Book, :author, :alphanumeric do |book|
      book.author = 'foo#bar'
    end

    ActiveRecord::Migration.deconstrain :books do |t|
      t.title :not_blank
      t.isbn :exact_length
      t.author :alphanumeric
    end

    assert_allows Book do |book|
      book.title  = '  '
      book.isbn   = 'asdf'
      book.author = 'foo#bar'
    end
  end

  def test_multiple_constraints_per_line
    ActiveRecord::Migration.constrain :books do |t|
      t.title :not_blank => true, :alphanumeric => true, :blacklist => %w(foo bar)
    end

    assert_prohibits Book, :title, [:not_blank, :alphanumeric] do |book|
      book.title = ' '
    end

    assert_prohibits Book, :title, :alphanumeric do |book|
      book.title = 'asdf@asdf'
    end

    assert_prohibits Book, :title, :blacklist do |book|
      book.title = 'foo'
    end

    ActiveRecord::Migration.deconstrain :books do |t|
      t.title :not_blank, :alphanumeric, :blacklist
    end

    assert_allows Book do |book|
      book.title = ' '
    end

    assert_allows Book do |book|
      book.title = 'asdf@asdf'
    end

    assert_allows Book do |book|
      book.title = 'foo'
    end
  end

  def test_multicolumn_constraint
    ActiveRecord::Migration.constrain :books, [:title, :isbn], :unique => true

    assert_allows Book do |book|
      book.title = 'foo'
      book.isbn = 'bar'
    end

    assert_allows Book do |book|
      book.title = 'foo'
      book.isbn = 'foo'
    end

    assert_prohibits Book, [:title, :isbn], :unique, 'unique' do |book|
      book.title = 'foo'
      book.isbn = 'bar'
    end

    ActiveRecord::Migration.deconstrain :books, [:title, :isbn], :unique

    assert_allows Book do |book|
      book.title = 'foo'
      book.isbn = 'bar'
    end
  end

  def test_multicolumn_constraint_block_syntax
    ActiveRecord::Migration.constrain :books do |t|
      t[:title, :isbn].all :unique => true
    end

    assert_allows Book do |book|
      book.title = 'foo'
      book.isbn = 'bar'
    end

    assert_allows Book do |book|
      book.title = 'foo'
      book.isbn = 'foo'
    end

    assert_prohibits Book, [:title, :isbn], :unique, 'unique' do |book|
      book.title = 'foo'
      book.isbn = 'bar'
    end

    ActiveRecord::Migration.deconstrain :books do |t|
      t[:title, :isbn].all :unique
    end

    assert_allows Book do |book|
      book.title = 'foo'
      book.isbn = 'bar'
    end
  end
end
