class Game < ActiveRecord::Base
  belongs_to :map
  belongs_to :match

    has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Game.to_s}'"

end
