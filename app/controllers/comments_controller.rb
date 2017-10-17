class CommentsController < ApplicationController
  get '/comments' do
    if logged_in?
      erb :"/comments/index"
    else
      redirect '/'
    end
  end
end
