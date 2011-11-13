Radibloga::Application.routes.draw do
    devise_for :users
    resource :account
    
    root :to => 'home#index'
    
    match 'blogs' => 'blogs#index', :as => 'all_posts'
    match 'blogs/next' => 'blogs#next', :as => 'next_post'
end
