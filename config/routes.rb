Rails.application.routes.draw do
  root to: 'home#index'

  namespace :hooks do
    post :github, to: 'github#create'
    post :aws, to: 'aws#create'
  end
end
