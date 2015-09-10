require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'pry'

require_relative 'config/application'
set :environment, :development

enable :sessions

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = "You need to sign in if you want to do that!"
    redirect '/'
  end
end

get '/' do
  #test meetups
  @meetups = Meetup.all.order(:title)
  erb :index
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/:id' do
  @meetup = Meetup.all.find_by id: params['id']
  erb :show
end

post '/:id/join' do
  authenticate!
  @meetup = Meetup.all.find_by id: params['id']
  if @meetup.users.include?(current_user)
    UserMeetup.find_by(user: current_user, meetup: @meetup).destroy
    flash[:notice] = "You are no longer attending this event"
  else
    UserMeetup.create(user: current_user, meetup: @meetup)
    flash[:notice] = "You are now attending this event"
  end
  redirect "/#{@meetup.id}"
end

post '/' do
  authenticate!
  var = Meetup.create(
  title: params[:title],
  description: params[:description],
  location: params[:location]
  )
  flash[:notice] = "Here is your new event"
  redirect "/#{var.id}"

end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
