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

  def self.find(id)
    found_patron = nil
    Patron.all().each() do |patron|
      if patron.id() == id.to_i()
        found_patron = patron
      end
    end
    found_patron
  end

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    @phone = attributes.fetch(:phone, @phone)
    @id = self.id()
    DB.exec("UPDATE patrons SET (name, phone) = ('#{@name}', '#{@phone}') WHERE id = #{@id};")

    attributes.fetch(:book_ids, []).each() do |book_id|
      DB.exec("INSERT INTO checkouts (book_id, patron_id) VALUES (#{book_id}, #{self.id()});")
    end
  end

  def books
    patron_book_history = []
    results = DB.exec("SELECT book_id FROM checkouts WHERE patron_id = #{self.id()};")
    results.each() do |result|
      book_id = result.fetch('book_id').to_i()
      book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
      title = book.first().fetch('title')
      authors = book.first().fetch('authors')
      genre = book.first().fetch('genre')
      patron_book_history.push(Book.new({:id => book_id, :title => title, :authors => authors, :genre => genre}))
    end
    patron_book_history
  end

  def delete
    DB.exec("DELETE FROM patrons WHERE id = #{self.id()};")
    DB.exec("DELETE FROM checkouts WHERE patron_id = #{self.id()};")
  end

end
