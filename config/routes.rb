Zhule::Application.routes.draw do

  root :to => 'index#index', :as => :root
  match 'sign_in' => 'index#index', :as => :sign_in
  match 'sign_up' => 'index#sign_up', :as => :sign_up, :via => [:get, :post]
  match 'sign_out' => 'index#sign_out', :as => :sign_out

  scope 'square' do
    match '/' => 'index#square', :as => :square
    match 'load_square_columns' => 'index#load_square_columns', :via => :get
  end
  
  # match 'square' => 'index#square', :as => :square
  match 'home' => 'home#index', :as => :home

  resources :users do
    member do
      post :follow
    end
  end

  resources :dialogs do
    collection do
      post :send_message
    end

    # member do
    #   post :read_messages
    # end
  end

  resources :assistances, :except => [:index] do
    member do
      get :joined
      post :join
    end

    collection do
      post :mark_as_helpful
      post :upload_photo
    end
  end

  resources :notifications, :only => [:index, :destroy]
  resources :comments, :only => [:create, :destroy]  

  scope 'settings' do
    match '/' => 'settings#index', :as => :settings, :via => [:get, :post]
    match 'password' => 'settings#password', :as => :setting_password, :via => [:get, :post]
    match 'avatar' => 'settings#avatar', :as => :setting_avatar, :via => [:get, :post]
    match 'avatar/crop' => 'settings#crop_avatar', :as => :crop_avatar
  end

   match 'auth/weibo/callback' => 'auth#weibo_login'
   match 'auth/new_user' => 'auth#new_user', :as => :auth_new_user, :via => 'POST'
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
