# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events, only: %i[create]
  resources :github_events, only: %i[create]
  resources :teams, only: %i[index new]
  # slack pingback to create team:
  get '/teams/create', to: 'teams#create', as: 'create_team'
  resources :threads, only: %i[index show]
  get '/cannon', to: 'cannon#create'
  post '/cannon', to: 'cannon#create'
end
