enable :sessions
require 'bcrypt'

get '/' do
  erb :index
end

post '/login' do
  @user_email = params[:email]
  @user_pass = params[:password]
  new_user = User.authenticate(@user_email, @user_pass)
  redirect '/' if new_user == nil
  session[:id] = new_user.id
  redirect '/secret_page'
end

post '/create_user' do
  created_user = User.create(email: params[:email],username: params[:username], password: params[:password])
  session[:id] = created_user.id
  redirect '/secret_page'
end


get '/secret_page' do
  current_user(session[:id])
  redirect '/' if @current_user == nil
  erb :secret_page
end

post '/logout' do
  session.clear
  redirect '/'
end


def current_user(session_id)
  @current_user = User.find(session_id) if session_id != nil
end
