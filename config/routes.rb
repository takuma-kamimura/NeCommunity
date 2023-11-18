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
      get :usercat
      # get 'usercat'
    end
  end
  resource :profile, only: %i(show edit update)
  resources :cats, only: %i(index new show edit create update destroy)
  resources :password_resets, only: %i[new create edit update] # パスワードリセット用
  # mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? # 開発環境用メーラー
  
  # resources :cats, only: [:index]
  resources :posts, only: %i(index new show edit create update destroy) do
    resources :comments, only: %i[create update destroy], shallow: true
    collection do
      get :likes
      get :bookmarks
      get :samebreedcats
      get :specifycats
      get :autocomplete
    end
  end
  resources :likes, only: %i(create destroy)
  resources :bookmarks, only: %i(create destroy)
  resources :health_records do
    collection do
      get :catrecord
      # get 'usercat'
    end
  end

end
