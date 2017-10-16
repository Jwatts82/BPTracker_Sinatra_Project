class CommentsController < ApplicationController

  get '/comments' do
    if logged_in?
      @user = current_user

      erb :"/comments/index"
    else
      redirect '/'
    end
  end
end
