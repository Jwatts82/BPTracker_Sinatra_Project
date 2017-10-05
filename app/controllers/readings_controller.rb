class ReadingsController < ApplicationController

  get '/readings' do
    if logged_in?
      @user = User.find(session[:u_id])

      readings = Reading.order('reading_date_time')

      @u_readings = readings.select do |reading|
        reading.person_id == @user.person_id
      end

      @message = session[:message]
      session[:message] = nil

      erb :'/readings/index'
    else
      redirect '/'
    end
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
                            comment = Comment.create(content: params[:content])
      reading.comments << comment

      reading.save

      redirect "/readings/#{reading.id}"
    else
      flash[:message] = 'Some required information is missing or your BP ' \
                        'reading is not possible. Please review your input.'

       erb :'/readings/new'
    end
  end

  post '/readings/selection' do
    @user = User.find(session[:u_id])

    readings =  Reading.where('reading_date_time BETWEEN ? AND ?',
                              params[:start_date], params[:end_date])

    @u_readings = readings.select do |reading|
      reading.person_id == @user.person_id
    end

    @start_date = params[:start_date].to_date.strftime("%m/%d/%Y")
    @end_date = params[:end_date].to_date.strftime("%m/%d/%Y")

    logged_in? ? (erb :'readings/selection') : (redirect '/')
  end

  get '/readings/:id' do
    if logged_in?
      @reading = Reading.find(params[:id])

      @date = @reading.reading_date_time.strftime("%m/%d/%Y")

      @time = @reading.reading_date_time.strftime("%I:%M%p")

      @message = session[:message]
      session[:message] = nil

      if @reading.person_id == current_user.person_id
        erb :'/readings/show'
      else
        session[:message] = "You don't have permission to access this reading."

        redirect '/readings?error=You do not have permission to access ' \
                 'that reading.'
      end
    else
      redirect '/'
    end
  end

  get '/readings/:id/edit' do
    @reading = Reading.find(params[:id])

    if @reading.person_id == current_user.person_id

      @date = @reading.date

      @time = @reading.time

      erb :'/readings/edit'
    else
      session[:message] = "You don't have permission to access this page."

      redirect '/readings?error=You do not have permission to access ' \
               'that page.'
    end
  end

  post '/readings/:id' do
    @reading = Reading.find(params[:id])

    v = params.select {|k,v| v unless k == 'content' }
    if !@reading.emtpy_input?(v) &&
       @reading.category_selector(params[:systolic], params[:diastolic])
      @reading.systolic = params[:systolic]
      @reading.diastolic = params[:diastolic]
      @reading.pulse = params[:pulse]

      datetime = @reading.datetime_sql_insert(params[:date], params[:time])
      @reading.reading_date_time = datetime

      grp = @reading.category_selector(params[:systolic], params[:diastolic])
      @reading.category = grp

      Comment.find(@reading.comments.ids).each do |comment|
        comment.update(content: params[:content]) unless params[:content].empty?
      end

      @reading.save

      session[:message] = 'Your updated was successful!'

      redirect "/readings/#{@reading.id}"
    else
      flash[:message] = 'Some required information is missing or your BP ' \
                        'reading is not possible. Please review your input.'

      @date = params[:date]
      @time = params[:time]
      @reading.systolic = params[:systolic]
      @reading.diastolic = params[:diastolic]
      @reading.pulse = params[:pulse]

      erb :'/readings/edit'
    end
  end

  delete '/readings/:id/delete' do
    reading = Reading.find(params[:id])

    if reading.person_id == current_user.person_id
      reading.destroy

      session[:message] = 'Your reading has been deleted.'

      redirect '/readings'
    else
      session[:message] = "You don't have permission to perform this action."

      redirect '/readings?error=You do not have permission to perform ' \
               'this action.'
    end
  end
end
