Radibloga::Application.routes.draw do
    devise_for :users
    resource :account
    
    root :to => 'home#index'
    match 'comment' => 'testcomment#index', :via => :get, :as => 'add_comment'
    match 'comment' => 'testcomment#submit', :via => :post
    
    match 'blogs' => 'blogs#index', :as => 'all_posts'
    match 'blogs/next' => 'blogs#next', :as => 'next_post'
end
