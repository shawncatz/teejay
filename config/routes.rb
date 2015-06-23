Rails.application.routes.draw do
  root to: 'home#index'

  namespace :hooks do
    post :github, to: 'github#create'
  end
end
