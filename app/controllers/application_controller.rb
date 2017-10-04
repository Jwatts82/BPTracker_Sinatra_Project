require './config/environment'
require 'rack-flash'
class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    @deleted_message = "Your account has been deleted." if session[:u_id].nil?

    erb :welcome
  end

  helpers do
    def logged_in?
      !!session[:u_id]
    end

    def current_user
      User.find(session[:u_id])
    end
  end

end
