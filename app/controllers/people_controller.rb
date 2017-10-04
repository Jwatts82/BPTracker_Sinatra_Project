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
      person.first_name = params[:first_name]
      person.last_name = params[:last_name]
      person.dob = params[:dob]
      person.age = person.age_calculator(params[:dob].to_date)
      person.save

      user = User.find(session[:u_id])
      user.person = person

      user.save

      redirect "/people/#{person.id}"
    end
  end

  get '/people/:id' do
    if logged_in?
      @person = Person.find(params[:id])

      @user = User.find(session[:u_id])

      @date = @person.date

      erb :'/people/show'
    else
      redirect '/'
    end
  end

  get "/people/:id/edit" do
    @person = Person.find(params[:id])

    @user = User.find(session[:u_id])

    erb :'/people/edit'
  end

  post '/people/:id' do
    @person = Person.find(params[:id])

    @user = User.find(session[:u_id])

    v = params.select {|k,v| v if k != 'password' }
    if @person.emtpy_input?(v)
      flash[:message] = 'Some required information is missing or incomplete.' \
                        ' Please correct your entries and try again.'

      erb :'people/edit'
    else
      @person.update(first_name: params[:first_name],
                     last_name: params[:last_name],
                     dob: params[:dob])
      @person.age = @person.age_calculator(params[:dob].to_date)
      @person.save

      @user.update(username: params[:username], password: params[:password])

      flash[:message] = "Your edit was successfully!"

      @date = @person.date

      erb :'people/show'
    end
  end
end
