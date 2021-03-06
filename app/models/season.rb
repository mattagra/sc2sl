class Season < ActiveRecord::Base

  #Associations
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :maps,  :join_table => "seasons_maps"
  has_many :matches, :dependent => :destroy
  has_many :regular_matches, :class_name => "Match", :conditions => "playoff_id is null"
  has_many :playoff_matches, :class_name => "Match", :conditions => "playoff_id is not null"
  has_many :games, :through => :matches


  scope :published, where(:published => true)

  #Nested Attributes
  accepts_nested_attributes_for :teams, :reject_if => proc { |a| a['selected'].blank? }

  #Attached
  has_attached_file :banner, {
    :styles => {
      :normal => "815x129!",
      :normal_gray => "815x129!",
      :small => "780x124!"
    },
    :url => "/shared/:class/:attachment/:id/:style_:basename.:extension",
    :path => ":rails_root/public:url",
    :convert_options => {
      :normal_gray => "-colorspace gray"
    }
    }

  #Validations
  validates :name, :presence => true

 

  def points(team)
    self.matches.where(:team0_id => team.id).where(:playoff_id => nil).inject(0){ |total, m| total + m.team0_points}.to_i +
      self.matches.where(:team1_id => team.id).where(:playoff_id => nil).inject(0){ |total, m| total + m.team1_points}.to_i
  end

  def wins(team)
    self.matches.where(:team0_id => team.id).where(:playoff_id => nil).where("matches.results > 0").count +
      self.matches.where(:team1_id => team.id).where(:playoff_id => nil).where("matches.results < 0").count
  end

  def losses(team)
    self.matches.where(:team0_id => team.id).where(:playoff_id => nil).where("matches.results < 0").count +
      self.matches.where(:team1_id => team.id).where(:playoff_id => nil).where("matches.results > 0").count
  end

  def game_wins(team)
    self.games.where("(matches.team0_id = #{team.id} and games.result = 0 and matches.playoff_id is null)").count +
      self.games.where("(matches.team1_id = #{team.id} and games.result = 1 and matches.playoff_id is null)").count
  end

  def game_losses(team)
    self.games.where("(matches.team0_id = #{team.id} and games.result = 1 and matches.playoff_id is null)").count +
      self.games.where("(matches.team1_id = #{team.id} and games.result = 0 and matches.playoff_id is null)").count
  end

  def current_week
    self.matches.where("matches.results <> 0 and playoff_id is null").maximum("weeks_id") || 1
	
  end
  
  def describe_status
    if self.matches.where("matches.results <> 0 and playoff_id is null").maximum("weeks_id")
	  "Round " + self.matches.where("matches.results <> 0 and playoff_id is null").maximum("weeks_id").to_s
	elsif self.matches.where("matches.results <> 0 and playoff_id is not null").maximum("playoff_id")
      self.describe_round(self.matches.where("matches.results <> 0 and playoff_id is not null").maximum("playoff_id"))
	else
	  "unknown"
	end
  end
  
  
  def self.describe_round(playoff_id)
    max_rounds = (playoff_id + 1) / 2
	round = 0
    if round == max_rounds
      "Grand Final"
    elsif round + 1 == max_rounds
      "Semi Finals"
    else
      "Round of "  + (2**(max_rounds - round + 1)).to_s
    end
  end
  
  



  def status
    1
  end

  def status_text
    case status
    when 0
      "new"
    when 1
      "ongoing"
    when 2
      "completed"
    end
  end


  def rank_for(team)
    self.teams.sort_by{|x| -self.points(x)}.index(team).to_i + 1
  end

end