require('rspec')
require('pg')
require('book')
require('pry')

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
  end
end

describe(Book) do
  describe('#==') do
    it('is the same book if it has the same title, authors, and genre') do
      book1 = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'adventure'})
      book2 = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'adventure'})
      expect(book1).to(eq(book2))
    end
  end

  describe('.all') do
    it('returns all the books in the library database') do
      expect(Book.all()).to(eq([]))
    end
  end

  describe('#save') do
    it('adds a book to the library database') do
      test_book = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'adventure'})
      test_book.save()
      expect(Book.all()).to(eq([test_book]))
    end
  end

end
