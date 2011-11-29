Radibloga::Application.routes.draw do
    devise_for :users
    namespace :manage do
      resources :accounts
      
      match 'blogs' => 'blogs#index', :via => :get, :as => 'blog'
      match 'blogs/import' => 'blogs#import', :via => :post, :as => 'import'
      
      match 'post/add/:id' => 'blogs#add_post', :as => 'add_imported_post'
      match 'post/unlock/:id' => 'blogs#unlock_add_post', :as => 'unlock_imported_post'
      
      match 'posts' => 'posts#index', :as => 'posts'
      match 'posts/:id' => 'posts#show', :as => 'post'
      match 'posts/comment/:id' => 'posts#close', :via => :delete, :as => 'close_comment'
    end
    
    root :to => 'home#index'
    match '/post/:id' => 'home#show', :via => :get, :as => 'show_post'
    match '/post/:id' => 'home#create', :via => :post, :as => 'post_comment'
    # match 'comment' => 'testcomment#index', :via => :get, :as => 'add_comment'
    # match 'comment' => 'testcomment#submit', :via => :post
    
end
