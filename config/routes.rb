Rails.application.routes.draw do

  root 'tops#top' # topページ

  resources :tops do
    collection do
      get :kiyac
      get :policy
    end
  end

  get 'login' => 'user_sessions#new', :as => :login # gem sorceryより。
  post 'login' => 'user_sessions#create' # gem sorceryのより。
  delete 'logout' => 'user_sessions#destroy', :as => :logout

  resources :users, only: %i(new create show) do
    collection do
      get :usercat
    end
  end
  resource :profile, only: %i(show edit update destroy) do
    collection do
      get :delete_confirmation
    end
  end
  resources :cats, only: %i(index new create update destroy)
  resources :password_resets, only: %i[new create edit update] # パスワードリセット用

  resources :posts, only: %i(index new show edit create update destroy) do
    resources :comments, only: %i[create update destroy], shallow: true
    collection do
      get :likes
      get :samebreedcats
      get :specifycats
      get :autocomplete
    end
  end
  resources :likes, only: %i(create destroy)

  resources :maps, only: %i(index show) do # GoogleマップAPIの導入により追加
    collection do
      get :search
    end
  end

  get 'line_events/show', to: 'line_events#show'
  post '/line_events', to: 'line_events#receive'
  put '/line_events', to: 'line_events#update'

  resources :post_by_cats, only: %i(index)

  namespace :admin do
    root to: 'posts#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :users, only: %i(index show edit update destroy)
    resources :posts, only: %i(index show edit update destroy)
    resources :cats, only: %i(index show edit update destroy)
    resources :tags, only: %i(index show edit update destroy)
    resources :comments, only: %i(index show edit update destroy)
  end
end
