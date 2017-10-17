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
    if !current_user.emtpy_input?(params[:user])
      current_user.update(params[:user])
      current_user.age = current_user.age_calculator(
        params[:user][:dob].to_date
      )
      current_user.save
      redirect "/users/#{current_user.id}"
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
      @date = current_user.user_friendly_date(current_user.dob)
      @message = session[:message]
      session[:message] = nil
      if current_user.id == params[:id].to_i
        erb :'users/show'
      else
        session[:message] = "You don't have permission to access this profile."
        redirect "/users/#{current_user.id}?error=You do not have " \
          "permission to access that profile."
      end
    else
      redirect '/'
    end
  end

  get '/users/:id/edit' do
    if current_user.id == params[:id].to_i
      erb :'users/edit'
    else
      session[:message] = "You don't have permission to access that page."
      redirect "/users/#{current_user.id}?error=You do not have " \
        "permission to access that page."
    end
  end

  post '/users/:id' do
    v = params[:user].select {|k,v| v if k != 'password' }
    if !current_user.emtpy_input?(v)
      current_user.update(params[:user])
      current_user.age = current_user.age_calculator(
        params[:user][:dob].to_date
      )
      current_user.save
      flash[:message] = "Your edit was successful!"
      @date = current_user.user_friendly_date(current_user.dob)
      erb :'users/show'
    else
      flash[:message] = 'Some required information is missing or incomplete.' \
        'Please correct your entries and try again.'
      current_user.first_name = params[:user][:first_name]
      current_user.last_name = params[:user][:last_name]
      current_user.dob = params[:user][:dob]
      current_user.username = params[:user][:username]
      current_user.password = params[:user][:password]
      erb :'users/edit'
    end
  end

  delete '/users/:id/delete' do
    if current_user.id == params[:id].to_i
      current_user.destroy
      session.clear
      session[:message] = 'Your account has been deleted'
      redirect '/'
    else
      redirect "/users/#{current_user.id}"
    end
  end

  get '/logout' do
    session.clear if logged_in?
    redirect '/'
  end
end
