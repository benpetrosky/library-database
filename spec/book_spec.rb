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

  describe('.find') do
    it('returns the book based on the id') do
      test_book = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'adventure'})
      test_book.save()
      test_book2 = Book.new({:id => nil, :title => 'The Alchemist 2', :authors => 'Paulo Cuelo', :genre => 'adventure'})
      test_book2.save()
      expect(Book.find(test_book2.id())).to(eq(test_book2))
    end
  end

  describe('#update') do
    it("lets you update books in the database") do
      book = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'Adventure'})
      book.save()
      book.update({:genre => 'Coming-of-age'})
      expect(book.genre()).to(eq('Coming-of-age'))
    end
    it('lets a patron checkout a book') do
      book = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'Adventure'})
      book.save()
      patron = Patron.new({:id => nil, :name => "Bob", :phone => '5555555'})
      patron.save()
      book.update({:patron_ids => [patron.id()]})
      expect(book.patrons()).to(eq([patron]))
    end
  end

  describe('#patrons') do
    it('displays the patrons that have checked out a book') do
      book = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'Adventure'})
      book.save()
      patron = Patron.new({:id => nil, :name => "Bob", :phone => '5555555'})
      patron.save()
      patron2 =  Patron.new({:id => nil, :name => "Bryan", :phone => '5544444'})
      patron2.save()
      book.update({:patron_ids => [patron.id(), patron2.id()]})
      expect(book.patrons()).to(eq([patron, patron2]))
    end
  end
  describe('#delete') do
    it('lets you delete a book from the database') do
      book = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'Adventure'})
      book.save()
      book2 = Book.new({:id => nil, :title => 'Captain Underpants', :authors => 'Paulo Cuelo', :genre => 'graphic novel'})
      book2.save()
      book.delete()
      expect(Book.all()).to(eq([book2]))
    end
  end
end
