class ReadingsController < ApplicationController

  get '/readings' do
    erb :'readings/index'
  end

  get '/readings/new' do
    logged_in? ? (erb :'/readings/new') : (redirect '/')
  end
end
