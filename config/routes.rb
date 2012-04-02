Sc2sl::Application.routes.draw do


  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  #resources :advertisements

  resources :newsletters

  get "/admin" => "admin#index", :as => :admin

  #get "/live" => "site#live", :as => :live

  get "/vote" => "vote_events#show_current"


  resources :replays, :controller => :games do
    member do
      get 'replay'
      post 'rate'
    end
  end
  
  match '/matches/:calendar_year/:calendar_month/' => 'matches#index', :constraints => { :calendar_year => /\d{4}/, :calendar_month => /\d{1,2}/},  :as => :matches


  resources :matches do
    resources :vote_events do
      resource :votes
    end
    resources :games do
      member do
        post 'rate'
        get 'replay'
      end
    end
  end

  resources :forums do
    resources :topics do
      resources :comments
    end
  end
  
  
  resources :maps

  resources :seasons

  resources :players

  get "/teams/new" => "teams#new"
  get "/teams/:name" => "teams#show", :as => :named_team
  resources :teams

  resources :moderations

  resources :comments
  
  match '/articles/:year/:month/:day/:url' => 'articles#show', :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/ },  :as => :named_article

  resources :articles do 
    resources :comments
    collection do
      get 'upload_image'
    end
  end
  resources :newsletters do
    member do
      post 'deliver'
    end
  end
  resources :password_resets
  #resource :user_session
  resource :account, :controller => :users
  resources :users

  #get 'logout' => 'user_sessions#destroy'
  #get 'login' => 'user_sessions#new'
  #get 'register' => 'users#new'
  match 'profile/:login' => 'users#show', :as => :profile
  #match 'finish_registration' => 'site#finish_registration', :as => :finish_registration
  #match 'finish_activation' => 'site#finish_activation', :as => :finish_activation

  #match '/activate/:activation_code' => 'activations#new', :as => :activate
  match '/terms' => "site#terms", :as => :terms
  match '/sitemap' => "site#sitemap", :as => :sitemap
  get '/panda/:caption' => "site#panda", :as => :panda


  root :to=>"site#index"



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
