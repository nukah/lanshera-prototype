Radibloga::Application.routes.draw do
    resource :account
    get "home/index"
    root :to => 'home#index'
    match 'blogs' => 'blogs#index', :as => 'all_posts'
    match 'blogs/next' => 'blogs#next', :as => 'next_post'
end
