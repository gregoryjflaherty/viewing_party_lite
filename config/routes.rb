Rails.application.routes.draw do
  root to:'welcome#index'
  post '/register', to: 'users#new'
  get '/register', to: 'users#new'

  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'


  resources :users, except: [:new, :show] do
    resources :discover, only: [:index]
    resources :movies, only: [:index, :show] do
      get '/viewing-party/new', to:'parties#new'
      post '/viewing-party/new', to:'parties#create'
    end
  end

  get '/users/dashboard', to: 'users#show'
end
