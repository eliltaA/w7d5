Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :subs
  # Defines the root path route ("/")
  # root "articles#index"
end
