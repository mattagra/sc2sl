class Match < ActiveRecord::Base

  #Associations
  has_many :games, :dependent => :destroy
  has_many :completed_games, :class_name => "Game", :conditions => "result is not null and result <> 0"
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Match.to_s}'", :dependent => :destroy
  belongs_to :team1, :class_name => "Team"
  belongs_to :team0, :class_name => "Team"
  belongs_to :season
  has_many :vote_events, :dependent => :destroy
  has_many :votes, :through => :vote_events, :dependent => :destroy


  #Accessors
  attr_accessor :maps
  
  #Nested Attributes
  accepts_nested_attributes_for :games

  #STATIC
  POINTS = [7,6,6,5,0,2,1,0,0]

  #validations
  validates :best_of, :presence => true, :numericality => true
  validates :team0, :presence => true, :if => Proc.new { |match| match.playoff_id.nil?}
  validates :team1, :presence => true, :if => Proc.new { |match| match.playoff_id.nil?}

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
      #If playoff Match, set team to next round.
      unless self.playoff_id.nil? or self.playoff_id == 0
        m = Match.find_by_season_id_and_playoff_id(self.season_id, (self.playoff_id / 2 - 1).ceil)
        if self.playoff_id % 2 == 0
          m.team0 = self.team0
        else
          m.team1 = self.team0
        end
        m.save
      end
    elsif self.games.select{|g| g.result == 1}.size == (self.best_of + 1) / 2
      self.results  = self.games.select{|g| g.result == 0}.size -  self.games.select{|g| g.result == 1}.size
      #If playoff Match, set team to next round.
      #unless self.playoff_id.nil? or self.playoff_id == 0
      #  m = Match.find_by_season_id_and_playoff_id(self.season_id, ((self.playoff_id + 1) / 2 - 1).ceil)
      #  if self.playoff_id % 2 == 0
      #    m.team0 = self.team1
      #  else
      #    m.team1 = self.team1
      #  end
      #  m.save
      #end
    end
  end

  def team0_wins
    self.games.select{|g| g.result == 0}.size
  end

  def team1_wins
    self.games.select{|g| g.result == 1}.size
  end
  
  def title
    if team0 and team1
    self.team0.name + " VS " + self.team1.name
	else
	"TBD"
	end
  end
  
  def short_title
    if team0 and team1
      self.team0.short_name + " vs " + self.team1.short_name
	else
	"TBD"
	end
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

  def winner
    if self.results.to_i != 0
      self.results > 0 ? self.team0 : self.team1
    else
      nil
    end
  end
    

end

