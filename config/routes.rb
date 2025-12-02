Rails.application.routes.draw do
  root 'draws#index'
  post 'draws/create', to: 'draws#create'
end
