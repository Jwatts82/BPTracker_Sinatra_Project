class PeopleController < ApplicationController
  get '/people/new' do
    erb :'/people/new'
  end

  get '/people/:id' do
    erb :'/people/show'
  end
end
