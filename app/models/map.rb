class Map < ActiveRecord::Base

  has_attached_file :photo,
    {:styles => {
      :large => "256x256",
      :normal => "128x128",
      :thumb => "64x64"
    }, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}
end
