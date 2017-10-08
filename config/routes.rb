Rails.application.routes.draw do
  resources :forecasts
  devise_for :users

  root to: 'dashboard#index'
end
