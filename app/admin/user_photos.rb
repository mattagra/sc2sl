ActiveAdmin.register User, :as => "User Photos" do
  scope :new_photos, :default => true
  scope :with_photos
  scope :unapproved_photos
  scope :approved_photos
  
  filter :login
  
  index do
    column "Login" do |user|
      link_to user.login, admin_user_path(user)
    end
    column "Photo" do |user|
      image_tag user.photo.url(:thumb)
    end
    column "Approved" do |user|
      if user.photo_approved
        "Approved"
      elsif user.photo_approved == false
        "Denied"
      else
        "---"
      end
    end
    column "Actions" do |user|
      strong {link_to("Approve", {:action => :update, :id => user.id, "user[photo_approved]" => 1}, :method => :put) }
      strong {link_to("Deny", {:action => :update, :id => user.id, "user[photo_approved]" => 0}, :method => :put) }
    end  
  end
  
  show :title => "Photo for #{user.login}" do |user|
    panel "Photo" do
      attributes_table_for user do
        row("Name") {user.name}
        row("Image") {image_tag user.photo.url(:normal)}
      end
    end
    active_admin_comments
  end
  
  
  
  controller do
    
    def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user], !current_user.is_super_admin?)
        flash[:notice] = "User updated!"
        redirect_to :action => :index
      else
        render :action => :index
      end
    end
    
  end
    
  
  
end