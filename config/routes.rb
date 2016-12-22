Rails.application.routes.draw do
  resources :settings, only: [:index, :edit, :update]
  resources :events
  resources :meetingtypes
  #resources :clients
  resources :programs
  devise_for :users , :except => 'create_user'
  resources :users #, :except => 'create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :user do
    root 'devise/sessions#new'
  end
  post '/create_user' => 'users#create_user'
  post '/events_repeat' => 'events#repeat'
  post '/events_confirm' => 'events#confirm'
  post '/program_paid_status_history' => 'programs#paid_status_history'
  post '/user_hourly_rate_history' => 'users#hourly_rate_history'
  get 'reports/weekly_activity'
  get 'reports/weekly_activity_send'
  get 'reports' =>'reports#index'
end
