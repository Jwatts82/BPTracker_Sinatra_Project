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
    if reading.emtpy_input?(v)
      flash[:message] = 'Some required information is missing or your BP ' \
                        'reading is not possible. Please review your input.'

       erb :'readings/new'
    else
      # create reading & comment objects
      redirect "/readings/#{reading.id}"
    end
  end
end
