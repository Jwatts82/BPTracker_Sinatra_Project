class UsersController < ApplicationController
  get '/signup' do
    logged_in? ? (redirect '/readings') : (erb :'/users/signup')
  end

  post '/signup' do
    user = User.new(params[:user])
    if user.save
      session[:user_id] = user.id
      redirect '/users/new'
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
      redirect '/readings'
    else
      flash[:message] = 'Username and password do not match. Please try again.'
      erb :'users/login'
    end
  end

  get '/users/new' do
    logged_in? ? (erb :'/users/new') : (redirect '/')
  end

  post '/users' do
    user = current_user
    if !user.emtpy_input?(params[:user])
      user.update(params[:user])
      user.age = user.age_calculator(params[:user][:dob].to_date)
      user.save
      redirect "/users/#{user.id}"
    else
      flash[:message] = 'Some required information is missing or incomplete.' \
        ' Please correct your entries and try again.'
      @first_name = params[:user][:first_name]
      @last_name = params[:user][:last_name]
      @dob = params[:user][:dob]
      erb :'/users/new'
    end
  end

  get '/users/:id' do
    if logged_in?
      @user = current_user
      @date = @user.user_friendly_date(@user.dob)
      @message = session[:message]
      session[:message] = nil
      if @user.id == params[:id].to_i
        erb :'users/show'
      else
        session[:message] = "You don't have permission to access this profile."
        redirect "/users/#{@user.id}?error=You do not have " \
          "permission to access that profile."
      end
    else
      redirect '/'
    end
  end

  get '/users/:id/edit' do
    @user = current_user
    if @user.id == params[:id].to_i
      erb :'users/edit'
    else
      session[:message] = "You don't have permission to access that page."
      redirect "/users/#{@user.id}?error=You do not have " \
        "permission to access that page."
    end
  end

  post '/users/:id' do
    @user = current_user
    v = params[:user].select {|k,v| v if k != 'password' }
    if !@user.emtpy_input?(v)
      @user.update(params[:user])
      @user.age = @user.age_calculator(params[:user][:dob].to_date)
      @user.save
      flash[:message] = "Your edit was successful!"
      @date = @user.user_friendly_date(@user.dob)
      erb :'users/show'
    else
      flash[:message] = 'Some required information is missing or incomplete.' \
        'Please correct your entries and try again.'
      @user.first_name = params[:user][:first_name]
      @user.last_name = params[:user][:last_name]
      @user.dob = params[:user][:dob]
      @user.username = params[:user][:username]
      @user.password = params[:user][:password]
      erb :'users/edit'
    end
  end

  delete '/users/:id/delete' do
    @user = current_user
    if @user.id == params[:id].to_i
      @user.destroy
      session.clear
      session[:message] = 'Your account has been deleted'
      redirect '/'
    else
      redirect "/users/#{user.id}"
    end
  end

  get '/logout' do
    session.clear if logged_in?
    redirect '/'
  end
end
