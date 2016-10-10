Rails.application.routes.draw do
  get 'sessions/new'

    resources :users do
    member do
      get :following, :followers
    end
  end

  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  root 'sessions#root'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
