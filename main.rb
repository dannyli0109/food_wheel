require 'sinatra'
require 'httparty'


require_relative "db_config"
require_relative "models/user"
require_relative "models/place"
require_relative "models/visit"


enable :sessions

google_api_key = "AIzaSyAyZQzt5po_uluzQYBD7sXvE8V4sEp_gCc"
photo_api_keys = [
  "AIzaSyDCuUncBxlPdhHTPMMs2zhJEEPiIzjzvnc",
  "AIzaSyDFbAKJeLVTAiOuB8jWySzFxjwTA4B5oMo",
  "AIzaSyAPafoHUamfW48UmUyK6u_3h6F0Q9gS2dA",
  "AIzaSyDxISDPDYGvCF0ah-mRaEdbpL4retm7Da0",
  "AIzaSyDX8rHEKJmYsgfKbqVkdXmkBBQrfvD1pTM"
]

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def calculate_duration time
    target_time = Time.parse(time)
    time_diff = Time.now - target_time
    minute = 60
    hour = minute * 60
    day = hour * 24
    returnString = ""
    if time_diff >= day
      return "#{(time_diff/day).to_i} days ago"
    elsif time_diff >= hour
      return "#{(time_diff/hour).to_i} hours ago"
    elsif time_diff >= minute
      return "#{(time_diff/minute).to_i} minutes ago"
    end
    return "#{time_diff.to_i} seconds ago"
  end
end

get '/' do
  erb :index
end

post '/places' do
  place = Place.new
  place.name = params[:name]
  place.vicinity = params[:vicinity]
  place.place_lat = params[:place_lat]
  place.place_lon = params[:place_lon]
  place.place_id = params[:place_id]
  if place.valid?
    place.save
  else
    place = Place.find_by(place_id: params[:place_id])
  end
  place = place.attributes

  redirect "/places/#{place["id"]}"
end

get "/places/:id" do
  @place = Place.find(params[:id]).attributes
  @result = HTTParty.get("https://maps.googleapis.com/maps/api/place/details/json?placeid=#{@place["place_id"]}&key=#{google_api_key}").parsed_response["result"]

  if !!@result["photos"]
    @photo_references = []
    @result["photos"].each do |photo|
      @photo_references.push(photo["photo_reference"])
    end
    @photos = []
    @photo_references.each do |reference|
      @photos.push("https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photoreference=#{reference}&key=#{photo_api_keys[rand(0..4)]}")
    end
    @photos = @photos.each_slice(3).to_a
  end
  erb :places
end


get '/users/new' do
  erb :sign_up
end

get '/roulette' do
  @current_latitude = params[:current_latitude]
  @current_longitude = params[:current_longitude]
  session[:current_location] = [@current_latitude, @current_longitude]
  @results = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{params[:current_latitude]},#{params[:current_longitude]}&radius=500&type=restaurant&key=#{google_api_key}").parsed_response["results"]
  erb :roulette
end

post '/users' do
  user = User.new
  user.email = params[:email]
  user.password = params[:password]
  user.password_confirmation = params[:password_confirmation]
  if user.valid?
    session[:message] = "Successfully registered"
    user.save
    session[:user_id] = user.id
    if session[:last_url]
      redirect session[:last_url]
    else
      redirect "/"
    end
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
    session[:message] = "Successfully logged in!"

    if session[:last_url]
      redirect session[:last_url]
    else
      redirect "/"
    end

  else
    @error_message = "Email or password incorrect"
    erb :login
  end
end

delete "/session" do
  session[:user_id] = nil
  session[:message] = "Logged out."
  session[:last_url] = nil
  redirect "/"
end

post "/visits" do
  visit = Visit.new
  visit.place_id = Place.find_by(place_id: params[:place_id])[:id]
  visit.user_id = session[:user_id]
  visit.visit_date = Time.new
  visit.save
  session[:message] = "Tagged"
  redirect "/users/#{session[:user_id]}"
end

get "/users/:id" do
  if logged_in?
    @visits = Visit.where(user_id: session[:user_id]).order('id Desc').limit(10)
    @places = []
    @visits.each do |visit|
      @places.push(Place.find(visit["place_id"]).attributes)
    end
    erb :user_profile
  else
    session[:message] = "Please log in!"
    redirect "/"
  end
end
