Rails.application.routes.draw do
  # get 'tops/top'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "tops#top" # topページ

  get 'login' => 'user_sessions#new', :as => :login # gem sorceryより。
  post 'login' => "user_sessions#create" # gem sorceryのより。
  delete 'logout' => 'user_sessions#destroy', :as => :logout

  resources :users, only: %i(new create show) do
    collection do
      get 'usercat'
    end
  end
  resource :profile, only: %i(show edit update)
  resources :cats, only: %i(index new show edit create update destroy)

  
  # resources :cats, only: [:index]
  resources :posts, only: %i(index new show edit create update destroy) do
    collection do
      get :likes
      get :bookmarks
    end
  end
  resources :likes, only: %i(create destroy)
  resources :bookmarks, only: %i(create destroy)

end
