Sc2sl::Application.routes.draw do

  available_languages = LOCALES.keys

  scope "(:locale)", :locale => /#{available_languages.join("|")}/ do
	  ActiveAdmin.routes(self)

	  devise_for :admin_users, ActiveAdmin::Devise.config
	  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

	  resources :newsletters

	  get "/admin" => "admin#index", :as => :admin
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
	  resource :account, :controller => :users
	  resources :users


	  match 'profile/:login' => 'users#show', :as => :profile
	  match '/terms' => "site#terms", :as => :terms
	  match '/sitemap' => "site#sitemap", :as => :sitemap


	  root :to=>"site#index"
  end





end
