class CommentsController < ApplicationController

  get '/comments' do
    if logged_in?
      user = User.find(session[:u_id])
      @person = Person.find(user.person_id)

      erb :"/comments/index"
    else
      redirect '/'
    end
  end
end
