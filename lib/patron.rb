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
      id = patron['id'].to_i()
      patrons.push(Patron.new({:id => id, :name => name, :phone => phone}))
    end
  patrons
  end

  def save
    result = DB.exec("INSERT INTO patrons (name, phone) VALUES ('#{@name}', #{@phone}) RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end
end
