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
      # create User obj
    end
  end
end
