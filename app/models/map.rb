class Map < ActiveRecord::Base

  has_and_belongs_to_many :seasons, :join_table => "seasons_maps"

  has_attached_file :photo,
    {:styles => {
      :large => "256x256",
      :normal => "128x128",
      :thumb => "64x64"
    }, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}

  def to_s
    self.name
  end

end
