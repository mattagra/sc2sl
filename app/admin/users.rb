ActiveAdmin.register User do

  scope :all, :default => true
  scope :recent
  

  filter :login
  filter :current_login_ip
  filter :first_name
  filter :last_name
  filter :country
  filter :race, :as => :check_boxes, :collection => ["protoss", "zerg", "terran", "random"]

  index do
    column "Login" do |user|
      link_to user.login, admin_user_path(user)
    end
    column :email
    column "Registered", :created_at
    column :current_login_ip
    column :first_name
    column :last_name
    column :country
    column :race
    default_actions
  end
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :login
      f.input :first_name
      f.input :last_name
      f.input :country
      f.input :birthdate
      f.input :race, :as => :select, :collection => ["protoss", "zerg", "terran", "random"]
    end
    f.inputs "SC2 Info" do
      f.input :bnet_server, :as => :select, :collection => User::SERVERS
      f.input :bnet_name
      f.input :bent_code
    end
    f.inputs "Bio" do
      f.input :photo
      f.input :photo_approved
      f.input :profile_text
      f.input :signature
      f.input :website
      f.input :caster
    end
    f.inputs "Options" do
      f.input :subscription
      f.input :time_zone
      f.input :roles, :as => :select, :collection => User::ROLES, :multiple => true
    end
    
    f.buttons

  end
  
  
  controller do
    cache_sweeper :user_sweeper
    def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user], !current_user.is_super_admin?)
        login = @user.login
        unless login == @user.login
          UserMailer.delay.username_change(@user, login)
        end
        flash[:notice] = "Account updated!"
        redirect_to :action => :show, :id => @user.id
      else
        render :action => :edit
      end
    end
    
  end
  
  

end
