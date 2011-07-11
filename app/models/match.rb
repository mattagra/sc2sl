class Match < ActiveRecord::Base
  has_many :games
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Match.to_s}'"
  belongs_to :team1, :class_name => "Team"
  belongs_to :team0, :class_name => "Team"
  accepts_nested_attributes_for :games
  belongs_to :season

  has_many :vote_events
  has_many :votes, :through => :vote_events

  
  def title
    self.team0.name + " VS " + self.team1.name
  end

  def casters
    unless self.caster_ids.nil?
    User.find(self.caster_ids.split(","))
    else
      []
    end
  end

  def casters=(new_casters)
    self.caster_ids = new_casters.collect{|c| c.login}.join(",")
  end

  

end
