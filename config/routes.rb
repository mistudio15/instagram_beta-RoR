Rails.application.routes.draw do
  
  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/ do

    resources :users do
      resources :posts, only: %i[create new destroy show edit update] do
        resources :comments, only: %i[create destroy]
      end
    end
    resources :sessions, :only => [:new, :create, :destroy]


    get '/signup', :to => 'users#new'
    get '/signin', :to => 'sessions#new'
    get '/signout', :to => 'sessions#destroy'

    get '/users/:user_id/posts/:id/likes', :to => 'posts#likes'

    root 'pages#about'
  end
end
