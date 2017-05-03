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
end
