class ReadingsController < ApplicationController

  get '/readings' do
    erb :'readings/index'
  end

  get '/readings/new' do
    logged_in? ? (erb :'/readings/new') : (redirect '/')
  end

  post "/readings" do
    user = User.find(session[:u_id])

    @date = params[:date]
    @time = params[:time]
    @systolic = params[:systolic]
    @diastolic = params[:diastolic]
    @pulse = params[:pulse]
    @comment = params[:comment]

    reading = Reading.new

    v = params.select {|k,v| v unless k == 'content' }
    if !reading.emtpy_input?(v) &&
       reading.category_selector(params[:systolic], params[:diastolic])
       reading.systolic = params[:systolic]
      reading.diastolic = params[:diastolic]
      reading.pulse = params[:pulse]
      reading.person_id = user.person_id

      datetime = reading.datetime_sql_insert(params[:date], params[:time])
      reading.reading_date_time = datetime

      reading.category = reading.category_selector(params[:systolic],
                                                  params[:diastolic])

      params[:content].empty? ? comment = Comment.create(content: 'no comment') :
                                comment = Comment.create(content: params[:comment])
      reading.comments << comment

      reading.save

      redirect "/readings/#{reading.id}"
    else
      flash[:message] = 'Some required information is missing or your BP ' \
                        'reading is not possible. Please review your input.'

       erb :'readings/new'
    end
  end

  get '/readings/:id' do
    if logged_in?
      erb :"/readings/show"
    else
      redirect '/'
    end
  end
end
