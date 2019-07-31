require('sinatra')
require('sinatra/reloader')
require('pry')
require('rspec')
require('./lib/author')
require('./lib/book')
require('./lib/checkouts')
require('./lib/user')
require('./lib/catalog')
also_reload('./lib/**/*.rb')

require('pg')

get ('/')do
  erb :default
end

get ('/checkouts')do
  erb :checkouts
end

post('/checkouts')do
  user_name = params[:user_name]
  user_id = User.search_by_name(user_name)
  book_id = params[:book_id].to_i
  # sooo.... this chains a bunch of methods to conver the current time to a date, change the date to the next month, and then convert it to a string in the following format: "2019-08-31"
  due_date = Time.new.to_date.next_month.to_s
  Checkout.save(user_id, book_id, due_date)
  redirect to ('/checkouts')
end

get ('/users')do
  erb :users
end

post ('/users')do
  user_name = params[:user_name]
  User.save(user_name)
  redirect to ('/users')
end

post ('/user_history')do
  # need to find a way to properly route to user page
  user_name = params[:user_name]
  redirect to ("/users/:user_name")
end

get ('users/:user_name')do
  user_name = params[:user_name]
  user_id = User.search_by_name(user_name)
  @books_checked_out = User.checked_out(user_id)
  erb :users
end

get ('/catalog')do
  Catalog.clear
  @catalog = Catalog.populate
  erb :catalog
end

post ('/catalog')do
  book_title = params[:book_title]
  Catalog.save(book_title)
  redirect to ('/catalog')
end

get ('/catalog/books')do
  erb :catalog
end

get ('/catalog/authors')do
  erb :catalog
end
