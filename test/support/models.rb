# Setting up sample migrations
class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string  :title
      t.string  :author
      t.integer :author_id
      t.integer :quantity
      t.string  :isbn
    end
  end
  
  def self.down
    drop_table :books
  end
end

class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :name
      t.string :bio
    end
  end
  
  def self.down
    drop_table :authors
  end
end

class Book < ActiveRecord::Base; end
class Author < ActiveRecord::Base; end
