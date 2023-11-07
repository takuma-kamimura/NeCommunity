Rails.application.routes.draw do
  # get 'tops/top'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'login' => 'user_sessions#new', :as => :login # gem sorceryより。
  post 'login' => "user_sessions#create" # gem sorceryのより。
  delete 'logout' => 'user_sessions#destroy', :as => :logout

  resources :users, only: %i(new create)
  resource :profile, only: %i(show edit update)
  root "tops#top" # topページ
end
