class Map < ActiveRecord::Base

  #Associations
  has_and_belongs_to_many :seasons, :join_table => "seasons_maps"

  #Attachments
  has_attached_file :photo,
    {:styles => {
      :large => "256x256",
      :normal => "128x128",
      :thumb => "64x64"
    }, :url => "/shared/maps/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}

  #Validations
  validates :name, :presence => true
  

  def to_s
    self.name
  end

end
