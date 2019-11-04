Rails.application.routes.draw do
  devise_for :users
  root "hams#index"
  resources :hams do 
    resources :comments, only: :create
  end
end
