class Game < ActiveRecord::Base
  belongs_to :map
  belongs_to :match

  has_attached_file :replay, {:url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}
    has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Game.to_s}'"

end
