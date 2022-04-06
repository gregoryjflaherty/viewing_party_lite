Rails.application.routes.draw do
  root to:'welcome#index'
  post '/register', to:'users#new'
  get '/register', to:'users#new'
  post '/login', to:'users#login_user'
  get '/login', to:'users#login_form'
  resources :users, except: [:new] do
    resources :discover, only: [:index]
    resources :movies, only: [:index, :show] do
      get '/viewing-party/new', to:'parties#new'
      post '/viewing-party/new', to:'parties#create'
    end
  end
end
