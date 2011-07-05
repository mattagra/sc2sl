Sc2sl::Application.routes.draw do

  resources :matches

  resources :game_ratings

  resources :maps

  resources :games

  resources :seasons

  resources :players

  resources :teams

  resources :moderations

  resources :comments
  
  match 'articles/:year/:month/:day/:url' => 'articles#show', :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/ },  :as => :named_article

  resources :articles do |articles|
    resources :comments
  end

  resources :partners

  resources :attachments

  resources :password_resets
  resource :user_session
  resource :account, :controller => :users
  resources :users

  get 'logout' => 'user_sessions#destroy'
  get 'login' => 'user_sessions#new'
  get 'register' => 'users#new'
  match 'profile/:id' => 'users#show', :as => :profile

  match '/activate/:activation_code' => 'activations#new', :as => :activate

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