Rails.application.routes.draw do
  resources :events
  resources :meetingtypes
  resources :clients
  resources :programs
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
end
