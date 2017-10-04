class PeopleController < ApplicationController
  get '/people/new' do
    erb :'/people/new'
  end
end
