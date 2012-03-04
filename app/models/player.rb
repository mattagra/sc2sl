class Player < ActiveRecord::Base

  #Associations
  belongs_to :team
  belongs_to :user
  has_many :comments, :through => :user


  #Validations
  validates :team, :presence => true
  validates :user, :presence => true
  validates :date_joined, :presence => true
  
  scope :race, lambda{|x| joins(:user) & User.race(x)}

  def active?
    self.date_quit == nil
  end


  def self.alphabetical
    self.joins(:user).order("LOWER(users.login) asc")
  end

  def games
    Game.where("games.player0_id = ? or games.player1_id = ?",self.id,self.id)
  end

  def login
    self.user.login if self.user
  end

  def to_s
    self.login if self.login
  end

  def events
    e = []
    e += self.user.players.collect{|p| [p.date_joined.to_datetime, "join", p]}
    e += self.user.retired_players.collect{|p| [p.date_quit.to_datetime, "quit", p]}
    e += self.games.reject{|m| m.result.nil?}.collect{|m| [m.scheduled_at.to_datetime, "game", m, self]}
    e
  end

  def wins_total
    self.games.reject { |game| game.winning_player != self  }.count
  end

  def games_total
    self.games.count
  end

  def wins_vs_protoss
    self.games.reject{ |game| (game.players - [self]).first.user.race != "protoss" }.reject { |game| game.winning_player != self  }.count
  end

  def games_vs_protoss
    self.games.reject{ |game| (game.players - [self]).first.user.race != "protoss" }.count
  end

  def wins_vs_zerg
    self.games.reject{ |game| (game.players - [self]).first.user.race != "zerg" }.reject { |game| game.winning_player != self  }.count
  end

  def games_vs_zerg
    self.games.reject{ |game| (game.players - [self]).first.user.race != "zerg" }.count
  end

  def wins_vs_terran
    self.games.reject{ |game| (game.players - [self]).first.user.race != "terran" }.reject { |game| game.winning_player != self  }.count
  end

  def games_vs_terran
    self.games.reject{ |game| (game.players - [self]).first.user.race != "terran" }.count
  end
  
  def commentable(user)
    true
  end
  
  

end
