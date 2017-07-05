require 'sinatra'
require "sinatra/reloader"
require "pry"

require_relative "db_config"
require_relative "models/user"

enable :sessions

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    User.find(id: session[:user_id])
  end
end

get '/' do
  erb :index
end

get '/users/new' do
  erb :sign_up
end

post '/users' do
  user = User.new
  user.email = params[:email]
  user.password = params[:password]
  user.password_confirmation = params[:password_confirmation]
  if user.valid?
    @message = "Successfully registered"
    redirect "/"
  else
    @error_message = []
    user.errors.messages.each do |key, value|
      value.each do |element|
        @error_message.push("#{key.capitalize} #{element}.")
      end
    end
    erb :sign_up
  end
end


get "/session/new" do
  erb :login
end

post "/session" do
  user = User.find_by(email: params[:email])
  if user && u.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/"
  end
end
