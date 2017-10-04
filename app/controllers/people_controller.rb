class PeopleController < ApplicationController
  get '/people/new' do
    logged_in? ? (erb :'/people/new') : (redirect '/')
  end

  get '/people/:id' do
    logged_in? ? (erb :'/people/show') : (redirect '/')
  end
end
