class PeopleController < ApplicationController
  get '/people/new' do
    logged_in? ? (erb :'/people/new') : (redirect '/')
  end

  post '/people' do

    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @dob = params[:dob]

    person = Person.new
    if person.emtpy_input?(params)
       flash[:message] = 'Some required information is missing or incomplete.' \
                         ' Please correct your entries and try again.'
       erb :'people/new'
    else
      # create new person object
      
      redirect "/people/#{person.id}"
    end
  end

  get '/people/:id' do
    logged_in? ? (erb :'/people/show') : (redirect '/')
  end
end
