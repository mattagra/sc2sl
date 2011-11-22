ActiveAdmin.register Player do

  scope :all, :default => true
  

  filter :team

  index do
    column "Login" do |player|
      link_to player.user.login, admin_player_path(player)
    end
    column :team
    default_actions
  end
  
 
  
  

end
