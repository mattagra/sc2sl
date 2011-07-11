class Season < ActiveRecord::Base

    has_and_belongs_to_many :teams
      has_and_belongs_to_many :maps,  :join_table => "seasons_maps"
    has_many :matches
    accepts_nested_attributes_for :teams, :reject_if => proc { |a| a['selected'].blank? }
    has_attached_file :banner, {:styles => {:normal => "815x129!", :small => "780x124!"}, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}
end
