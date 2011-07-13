class Match < ActiveRecord::Base
  has_many :games
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Match.to_s}'"
  belongs_to :team1, :class_name => "Team"
  belongs_to :team0, :class_name => "Team"
  accepts_nested_attributes_for :games
  belongs_to :season

  has_many :vote_events
  has_many :votes, :through => :vote_events

  attr_accessor :maps


  validates :best_of, :presence => true, :numericality => true

  def before_create
    maps_count = maps.size
    self.best_of.times do |i|
      map_num = i % maps_count
      map = self.maps[map_num] || nil
      self.games.build(:map => map, :match_order => i + 1)
    end
  end
  
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

  def teams
    [self.team0,self.team1]
  end

  

end
