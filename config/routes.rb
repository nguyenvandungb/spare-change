Rails.application.routes.draw do

  root "users#show"
  resources :users, only: [:new, :create, :show] do
    member do
      post "plaid" => "plaid#create"
    end
  end

  resources :sessions, only: [:new, :create, :destroy]


end
