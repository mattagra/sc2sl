class Season < ActiveRecord::Base

  #Associations
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :maps,  :join_table => "seasons_maps"
  has_many :matches
  has_many :games, :through => :matches

  #Nested Attributes
  accepts_nested_attributes_for :teams, :reject_if => proc { |a| a['selected'].blank? }

  #Attached
  has_attached_file :banner, {:styles => {:normal => "815x129!", :small => "780x124!"}, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}

  #Validations
  validates :name, :presence => true
  

  def points(team)
    self.matches.where(:team0_id => team.id).inject(0){ |total, m| total + m.team0_points}.to_i +
      self.matches.where(:team1_id => team.id).inject(0){ |total, m| total + m.team1_points}.to_i
  end

  def wins(team)
    self.matches.where(:team0_id => team.id).where("matches.results > 0").count +
      self.matches.where(:team1_id => team.id).where("matches.results < 0").count
  end

  def losses(team)
    self.matches.where(:team0_id => team.id).where("matches.results < 0").count +
      self.matches.where(:team1_id => team.id).where("matches.results > 0").count
  end

  def game_wins(team)
    self.games.where("matches.team0_id = #{team.id}").where("games.result == 0").count +
      self.games.where("matches.team1_id = #{team.id}").where("games.result == 1").count
  end

  def game_losses(team)
    self.games.where("matches.team0_id = #{team.id}").where("games.result == 1").count +
      self.games.where("matches.team1_id = #{team.id}").where("games.result == 0").count
  end

end