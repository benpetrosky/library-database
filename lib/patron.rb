class Patron
  attr_accessor(:id, :name, :phone)

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @phone = attributes[:phone]
  end

  def ==(other_patron)
    self.name() == other_patron.name() && self.phone() == other_patron.phone()
  end
  def self.all
    patrons_list = DB.exec("SELECT * FROM patrons;")
    patrons = []
    patrons_list.each() do |patron|
      name = patron['name']
      phone = patron['phone']

      patrons.push(Patron.new(:name => name, :phone => phone))
    end
  patrons
  end
end