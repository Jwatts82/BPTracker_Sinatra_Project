class ReadingsController < ApplicationController

  get '/readings' do
    if logged_in?
      @readings = current_user.readings.order('reading_date_time')
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
    user = current_user

    @date = params[:date]
    @time = params[:time]
    @systolic = params[:systolic]
    @diastolic = params[:diastolic]
    @pulse = params[:pulse]
    @comment = params[:comment]

    reading = Reading.new

    v = params.select {|k,v| v unless k == 'content' }
    if !reading.emtpy_input?(v) &&
       reading.category_selector(
        params[:systolic],
        params[:diastolic]
      )
      reading.systolic = params[:systolic]
      reading.diastolic = params[:diastolic]
      reading.pulse = params[:pulse]
      reading.user_id = user.id

      datetime = reading.datetime_sql_insert(
        params[:date],
        params[:time]
      )
      reading.reading_date_time = datetime

      reading.category = reading.category_selector(
        params[:systolic],
        params[:diastolic]
      )

      params[:content].empty? ?
        params[:content] = 'no comment' :
        params[:content]
      comment = Comment.create(
        content: params[:content]
      )
      reading.comments << comment
      reading.save

      redirect "/readings/#{reading.id}"
    else
      flash[:message] =
        'Some required information is missing ' \
        'or your BP reading is not possible ' \
        'Please review your input.'

       erb :'/readings/new'
    end
  end

  post '/readings/selection' do
    @user = current_user

    readings =  Reading.where(
      'reading_date_time BETWEEN ? AND ?',
      params[:start_date], params[:end_date]
    )

    @user_readings = readings.select do |reading|
      reading.user_id == @user.id
    end

    @start_date = params[:start_date].to_date.strftime("%m/%d/%Y")
    @end_date = params[:end_date].to_date.strftime("%m/%d/%Y")

    erb :'readings/selection'
  end

  get '/readings/:id' do
    if logged_in?
      @reading = Reading.find(params[:id])

      @date = @reading.user_friendly_date(@reading.reading_date_time)

      @time = @reading.user_friendly_time

      @message = session[:message]
      session[:message] = nil

      if @reading.user_id == current_user.id
        erb :'/readings/show'
      else
        session[:message] =
          "You don't have permission to " \
          "access this reading."

        redirect '/readings?error=You do not ' \
          'have permission to access that reading.'
      end
    else
      redirect '/'
    end
  end

  get '/readings/:id/edit' do
    @reading = Reading.find(params[:id])

    if @reading.user_id == current_user.id
      @date = @reading.cpu_date

      @time = @reading.cpu_time

      erb :'/readings/edit'
    else
      session[:message] =
        "You don't have permission to access this page."

      redirect '/readings?error=You do not have ' \
        'permission to access that page.'
    end
  end

  post '/readings/:id' do
    @reading = Reading.find(params[:id])

    v = params.select {|k,v| v unless k == 'content' }
    if !@reading.emtpy_input?(v) &&
       @reading.category_selector(
        params[:systolic],
        params[:diastolic]
      )
      @reading.systolic = params[:systolic]
      @reading.diastolic = params[:diastolic]
      @reading.pulse = params[:pulse]

      datetime = @reading.datetime_sql_insert(
        params[:date],
        params[:time]
      )
      @reading.reading_date_time = datetime

      pressure_category = @reading.category_selector(
        params[:systolic],
        params[:diastolic]
      )
      @reading.category = pressure_category

      comments = Comment.find(@reading.comments.ids)
      comments.each do |comment|
        comment.update(content: params[:content]) unless
          params[:content].empty?
      end

      @reading.save

      session[:message] = 'Your update was successful!'

      redirect "/readings/#{@reading.id}"
    else
      flash[:message] =
        'Some required information is missing or ' \
        'your BP reading is not possible. Please ' \
        'review your input.'

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

    if reading.user_id == current_user.id
      reading.destroy

      session[:message] =
        'Your reading has been deleted.'

      redirect '/readings'
    else
      session[:message] = "You don't have " \
        "permission to perform this action."

      redirect '/readings?error=You do not have ' \
        'permission to perform this action.'
    end
  end
end
