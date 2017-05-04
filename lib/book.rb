class Book
  attr_accessor(:id, :title, :authors, :genre)

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @authors = attributes[:authors]
    @genre = attributes[:genre]
  end

  def ==(other_book)
    self.title() == other_book.title() && self.authors() == other_book.authors() && self.genre() == other_book.genre()
  end

  def self.all
    books_list = DB.exec("SELECT * FROM books;")
    books = []
    books_list.each() do |book|
      title = book['title']
      authors = book['authors']
      genre = book['genre']
      id = book['id'].to_i()
      books.push(Book.new({:id => id, :title => title, :authors => authors, :genre => genre}))
    end
    books
  end

  def save
    result = DB.exec("INSERT INTO books (title, authors, genre) VALUES ('#{@title}', '#{@authors}', '#{@genre}') RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  def self.find(id)
    found_book = nil
    Book.all().each() do |book|
      if book.id() == id.to_i()
        found_book = book
      end
    end
    found_book
  end

  def update(attributes)
    @title = attributes.fetch(:title, @title)
    @id = self.id()
    @authors = attributes.fetch(:authors, @authors)
    @genre = attributes.fetch(:genre, @genre)

    DB.exec("UPDATE books SET (title, authors, genre) = ('#{@title}', '#{@authors}', '#{@genre}') WHERE id = #{@id};")

    attributes.fetch(:patron_ids, []).each() do |patron_id|
      DB.exec("INSERT INTO checkouts (book_id, patron_id) VALUES (#{self.id()}, #{patron_id});")
    end
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{self.id()};")
    DB.exec("DELETE FROM checkouts WHERE book_id = #{self.id()};")
  end

  def patrons
    book_checkout_history = []
    results = DB.exec("SELECT patron_id FROM checkouts WHERE book_id = #{self.id()};")
    results.each() do |result|
      patron_id = result.fetch('patron_id').to_i()
      patron = DB.exec("SELECT * FROM patrons WHERE id = #{patron_id};")
      name = patron.first().fetch('name')
      phone = patron.first().fetch('phone')
      book_checkout_history.push(Patron.new({:id => patron_id, :name => name, :phone => phone}))
    end
    book_checkout_history
  end
end
