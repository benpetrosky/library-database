require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/book")
require("./lib/patron")

require("pg")
require('pry')

DB = PG.connect({:dbname => "library"})

get("/") do
  erb(:index)
end

get('/books/new') do
  erb(:add_book_to_lib_form)
end

post('/add_book') do
  title = params['title']
  authors = params['authors']
  genre = params['genre']
  @book = Book.new({:id => nil, :title => title, :authors => authors, :genre => genre})
  @book.save()
  @books = Book.all()
  erb(:book_catalog)
end

get('/book/:id') do
  @book = Book.find(params['id'].to_i())
  @patrons = Patron.all()
  erb(:book)
end

patch("/books/:id") do
  @book = Book.find(params['id'].to_i())
  patron_ids = params.fetch('patron_ids')
  @book.update({:patron_ids => patron_ids})
  @patrons = Patron.all()
  erb(:book)
end

delete('/books/:id') do
  @book = Book.find(params['id'].to_i())
  @book.delete()
  @books = Book.all()
  erb(:book_catalog)
end

get('/book_catalog') do
  @books = Book.all()
  erb(:book_catalog)
end

get('/patrons/new') do
  erb(:patron_form)
end

post('/patron_info') do
  name = params['name']
  phone = params['phone']
  @patron = Patron.new({:id => nil, :name => name, :phone => phone})
  @patron.save()
  @patrons = Patron.all()
  erb(:library_patrons)
end

get('/patron/:id') do
  @patron = Patron.find(params['id'])
  @books = Book.all()
  erb(:patron_details)
end

patch('/patron/:id') do
  @patron = Patron.find(params['id'])
  book_ids = params.fetch('book_ids')
  @patron.update({:book_ids => book_ids})
  @books = Book.all()
  erb(:patron_details)
end

delete('/library_patrons/:id') do
  @patron = Patron.find(params['id'])
  @patron.delete()
  @patrons = Patron.all()
  erb(:library_patrons)
end

get('/library_patrons') do
  @patrons = Patron.all()
  erb(:library_patrons)
end
