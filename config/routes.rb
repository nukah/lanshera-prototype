Radibloga::Application.routes.draw do
    devise_for :users
    namespace :manage do
      resources :accounts
      
      match 'blogs' => 'blogs#index', :via => :get, :as => 'blog'
      match 'blogs/import' => 'blogs#import', :via => :post, :as => 'import'
    end
    
    root :to => 'home#index'
    match 'comment' => 'testcomment#index', :via => :get, :as => 'add_comment'
    match 'comment' => 'testcomment#submit', :via => :post
    
end
