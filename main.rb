require 'sinatra'
# require "sinatra/reloader"
require "pry"
require 'httparty'


require_relative "db_config"
require_relative "models/user"
require_relative "models/place"
require_relative "models/visit"


enable :sessions

google_api_key = ENV["google_address_api_key"]

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
  erb :index
end

get '/places' do
  @place = Place.new
  @place.name = params[:name]
  @place.vicinity = params[:vicinity]
  @place.place_lat = params[:place_lat]
  @place.place_lon = params[:place_lon]
  @place.place_id = params[:place_id]
  if @place.valid?
    @place.save
  else
    @place = Place.find_by(place_id: params[:place_id])
  end
  @place = @place.attributes
  erb :places
end

get '/users/new' do
  erb :sign_up
end

get '/roulette' do
  @current_latitude = params[:current_latitude]
  @current_longitude = params[:current_longitude]
  @results = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{params[:current_latitude]},#{params[:current_longitude]}&radius=500&type=restaurant&keyword=cruise&key=#{google_api_key}").parsed_response["results"]
  erb :roulette
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
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/"
  else
    @error_message = "Email or password incorrect"
    erb :login
  end
end

delete "/session" do
  session[:user_id] = nil
  redirect "/"
end
