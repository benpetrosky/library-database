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

end
