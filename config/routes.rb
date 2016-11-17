Rails.application.routes.draw do
  resources :events
  resources :meetingtypes
  resources :clients
  resources :programs
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :user do
    root 'devise/sessions#new'
  end
  post '/eventsrepeat' => 'events#repeat'
  get 'reports/weekly_activity'
  get 'reports/weekly_activity_send'
  get 'reports' =>'reports#index'
end
