class UsersController < ApplicationController

  get '/signup' do
    logged_in? ? (redirect '/readings') : (erb :"/users/signup")
  end

  post '/signup' do
    user = User.new(params[:user])
    if user.save
      session[:user_id] = user.id
      redirect '/user/new'
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
    user = current_user

    if !user.emtpy_input?(params[:user])
      user.update(params[:user])
      user.age = user.age_calculator(params[:user][:dob].to_date)
      user.save

      redirect "/user/#{user.id}"
    else
      flash[:message] = 'Some required information is missing or incomplete.' \
        ' Please correct your entries and try again.'

      @first_name = params[:user][:first_name]
      @last_name = params[:user][:last_name]
      @dob = params[:user][:dob]

      erb :'/users/new'
    end
  end

  get '/user/:id' do
    binding.pry
  end

  get '/logout' do
    session.clear if logged_in?

    redirect '/'
  end
end
