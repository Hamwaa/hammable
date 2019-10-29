Rails.application.routes.draw do
  root "hams#index"
  resources :hams, only: [:new, :create]
end
