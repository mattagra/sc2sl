class Match < ActiveRecord::Base
  has_many :games
    has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Match.to_s}'"
  belongs_to :team1, :class_name => "Team"
  belongs_to :team0, :class_name => "Team"
  accepts_nested_attributes_for :games
  belongs_to :season

end
