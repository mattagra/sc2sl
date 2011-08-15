class Match < ActiveRecord::Base

  #Associations
  has_many :games
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Match.to_s}'"
  belongs_to :team1, :class_name => "Team"
  belongs_to :team0, :class_name => "Team"
  belongs_to :season
  has_many :vote_events
  has_many :votes, :through => :vote_events


  #Accessors
  attr_accessor :maps
  
  #Nested Attributes
  accepts_nested_attributes_for :games

  #STATIC
  POINTS = [7,6,6,5,0,2,1,0,0]

  #validations
  validates :best_of, :presence => true, :numericality => true
  validates :team0, :presence => true
  validates :team1, :presence => true
  

  #triggers
  before_save :determine_status
  before_create :build_maps

  def build_maps
    maps_count = maps.size
    self.best_of.times do |i|
      map_num = i % maps_count
      map = self.maps[map_num] || nil
      self.games.build(:map => map, :match_order => i + 1)
    end
  end

  def determine_status
    if self.games.select{|g| g.result == 0}.size == (self.best_of + 1) / 2
      self.results  = self.games.select{|g| g.result == 0}.size -  self.games.select{|g| g.result == 1}.size
    elsif self.games.select{|g| g.result == 1}.size == (self.best_of + 1) / 2
      self.results  = self.games.select{|g| g.result == 0}.size -  self.games.select{|g| g.result == 1}.size
    end
  end
  
  def title
    self.team0.name + " VS " + self.team1.name
  end

  def casters
    unless self.caster_ids.nil?
      User.find(self.caster_ids)
    else
      []
    end
  end


 def caster_ids=(new_caster_ids)
   self["caster_ids"] = new_caster_ids.join(",")
 end

 def caster_ids
   self["caster_ids"].split(",") if self["caster_ids"]
  end

  def casters=(new_casters)
    self.caster_ids = new_casters.collect{|c| c.login}.join(",")
  end

  def teams
    [self.team0,self.team1]
  end

  def team0_points
    i = 4 - self.results.to_i
    Match::POINTS[i]
  end

  def team1_points
    i = 4 + self.results.to_i
    Match::POINTS[i]
  end

  

end
