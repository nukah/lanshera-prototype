Radibloga::Application.routes.draw do
    devise_for :users
    match 'account' => 'account#show', :via => :get, :as => 'account'
    match 'account/new' => 'account#new', :via => :get, :as => 'new_account'
    match 'account' => 'account#create', :via => :post, :as => 'create_account'
    match 'account/:id' => 'account#delete', :via => :delete, :as => 'delete_account'
    match 'account/edit/:id' => 'account#edit', :via => :get, :as => 'edit_account'
    match 'account/:id' => 'account#update', :via => :put, :as => 'update_account'
    
    match 'blogs' => 'blogs#show', :via => :get, :as => 'show_blog'
    match 'blogs/import' => 'blogs#import', :via => :post, :as => 'import_blog'
    
    root :to => 'home#index'
    match 'comment' => 'testcomment#index', :via => :get, :as => 'add_comment'
    match 'comment' => 'testcomment#submit', :via => :post
    
end
