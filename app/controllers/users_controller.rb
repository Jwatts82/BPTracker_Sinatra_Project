class UsersController < ApplicationController

  get '/signup' do
    erb :"/users/signup"
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
    erb :'users/login'
end
end
