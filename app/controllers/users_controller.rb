class UsersController < ApplicationController

  get '/signup' do
    logged_in? ? (redirect '/readings') : (erb :"/users/signup")
  end

  post '/signup' do

    if params[:username].empty? || params[:password].empty?
      flash[:message] = 'Some required information is missing or incomplete.' \
                        ' Please correct your entries and try again.'

      erb :"/users/signup"
    else
      user = User.create(username: params[:username],
                         password: params[:password])

      session[:u_id] = user.id

      redirect '/people/new'
    end
  end

  get '/login' do
    logged_in? ? (redirect '/readings') : (erb :'users/login')
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      flash[:message] = "Welcome Back!"

      session[:u_id] = user.id

      redirect '/readings'
    else
      flash[:message] = 'Username and password do not match. Please try again.'

      erb :'users/login'
    end
  end

  get '/logout' do
    session.clear if logged_in?

    redirect '/'
  end
end
