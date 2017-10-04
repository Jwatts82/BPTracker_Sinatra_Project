class ReadingsController < ApplicationController

  get '/readings' do
    erb :'readings/index'
  end

  get '/readings/new' do
    logged_in? ? (erb :'/readings/new') : (redirect '/')
  end

  post "/readings" do
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

      redirect "/readings/#{reading.id}"
    else
      flash[:message] = 'Some required information is missing or your BP ' \
                        'reading is not possible. Please review your input.'

       erb :'readings/new'
    end
  end
end
