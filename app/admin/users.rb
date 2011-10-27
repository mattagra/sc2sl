ActiveAdmin.register User do

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
    default_actions

  end

end
