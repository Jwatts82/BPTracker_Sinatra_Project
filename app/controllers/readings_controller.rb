class ReadingsController < ApplicationController

  get '/readings' do
    erb :'readings/index'
  end
end
