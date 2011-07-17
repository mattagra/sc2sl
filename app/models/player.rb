class Player < ActiveRecord::Base

  #Associations
  belongs_to :team
  belongs_to :user
  has_many :comments, :through => :user


  #Validations
  validates :team, :presence => true
  validates :user, :presence => true
  validates :date_joined, :presence => true

  def games
    Game.where("games.player0_id = ? or games.player1_id = ?",self.id,self.id)
  end

  def login
    self.user.login if self.user
  end

  def to_s
    self.login if self.login
  end


end
