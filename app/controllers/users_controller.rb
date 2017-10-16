class UsersController < ApplicationController

  get '/signup' do
    logged_in? ? (redirect '/readings') : (erb :"/users/signup")
  end

  post '/signup' do
    user = User.new(params[:user])
    if user.save
      session[:user_id] = user.id
      redirect '/people/new'
    else
      flash[:message] = user.errors.full_messages.join(', ')
      erb :'/users/signup'
    end
  end

  get '/login' do
    logged_in? ? (redirect '/readings') : (erb :'users/login')
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:message] = "Welcome Back!"

      session[:user_id] = user.id

      # redirect '/readings'
      redirect "/user/#{user.id}"
    else
      flash[:message] = 'Username and password do not match. Please try again.'

      erb :'users/login'
    end
  end

  get '/user/new' do
    logged_in? ? (erb :'/users/new') : (redirect '/')
  end

  post '/user' do
    binding.pry
  end

  get '/logout' do
    session.clear if logged_in?

    redirect '/'
  end
end
