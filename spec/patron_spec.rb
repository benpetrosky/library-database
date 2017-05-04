require('rspec')
require('pg')
require('patron')

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM patrons *;")
  end
end

describe(Patron) do
  describe("#==") do
    it('is the same patron if it has the same name, and phone.') do
      patron1 = Patron.new({:id => nil, :name => "Bob", :phone => '5555555'})
      patron2 = Patron.new({:id => nil, :name => "Bob", :phone => '5555555'})
      expect(patron1).to(eq(patron2))
    end
  end

  describe('.all') do
    it('returns all the patrons in the library database') do
      expect(Patron.all()).to(eq([]))
    end
  end
  describe('#save') do
    it('adds a patron to the library database') do
      test_patron = Patron.new({:id => nil, :name => 'Billy Bob', :phone => '5558907'})
      test_patron.save()
      expect(Patron.all()).to(eq([test_patron]))
    end
  end

  describe('.find') do
    it('returns the patron based on the id') do
      test_patron = Patron.new({:id => nil, :name => 'Billy Bob', :phone => '5558907'})
      test_patron.save()
      test_patron2 = Patron.new({:id => nil, :name => 'Billy Jean', :phone => '5558907'})
      test_patron2.save()
      expect(Patron.find(test_patron2.id())).to(eq(test_patron2))
    end
  end

  describe('#update') do
    it('updates patrons in the database') do
      patron = Patron.new({:id => nil, :name => "Bob", :phone => '5555555'})
      patron.save()
      patron.update({:name => 'Robert'})
      expect(patron.name()).to(eq('Robert'))
    end

    it('lets a book be checked out by a patron') do
      book1 = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'Adventure'})
      book1.save()
      book2 = Book.new({:id => nil, :title => 'Captain Underpants', :authors => 'Paulo Cuelo', :genre => 'Graphic Novel'})
      book2.save()
      patron = Patron.new({:id => nil, :name => "Bob", :phone => '5555555'})
      patron.save()
      patron.update({:book_ids => [book1.id(), book2.id()]})
      expect(patron.books()).to(eq([book1, book2]))
    end
  end

  describe('#books') do
    it('returns all of the books that a person has checked out') do
      book1 = Book.new({:id => nil, :title => 'The Alchemist', :authors => 'Paulo Cuelo', :genre => 'Adventure'})
      book1.save()
      book2 = Book.new({:id => nil, :title => 'Captain Underpants', :authors => 'Paulo Cuelo', :genre => 'Graphic Novel'})
      book2.save()
      patron = Patron.new({:id => nil, :name => "Bob", :phone => '5555555'})
      patron.save()
      patron.update({:book_ids => [book1.id(), book2.id()]})
      expect(patron.books()).to(eq([book1, book2]))
    end
  end

  describe('#delete') do
    it('removes patrons from the database') do
      patron = Patron.new({:id => nil, :name => "Bob", :phone => '5555555'})
      patron.save()
      patron.delete()
      expect(Patron.all()).to(eq([]))
    end
  end

end
