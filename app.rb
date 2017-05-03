require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/book")
require("./lib/patron")
require("pg")

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
  erb(:book)
end

get('/book_catalog') do
  @books = Book.all()
  erb(:book_catalog)
end
