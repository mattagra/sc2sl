class Team < ActiveRecord::Base

  #Associations
  belongs_to :country
  belongs_to :user
  has_and_belongs_to_many :seasons
  has_many :players, :conditions => ["date_quit is null"]

  has_many :retired_players, :class_name => "Player", :conditions => ["date_quit is not null"]

  has_many :all_players, :class_name => "Player"


  #Validations
  validates :name, :presence => true, :format => {:with =>  /^[0-9a-zA-Z\s\-]+$/}
  validates :country, :presence => true
  validates :short_name, :presence => true, :format => {:with =>  /^[0-9a-zA-Z\s\-]+$/}
  validates :description, :length => {:maximum => 546}
  scope :alphabetical, order('LOWER(name) asc')

  def matches
    Match.where("team0_id = ? or team1_id = ?", self.id, self.id)
  end

  def games
    self.matches.collect{|m| m.completed_games}.flatten.uniq
  end


  has_attached_file :photo,
    {:styles => {
      :large => "180x180!",
      :normal => "100x100!",
      :thumb => "32x32!"
    }, :url => "/shared/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}

  alias :coach :user

  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Team.to_s}'"


  def to_s
    self.name
  end

  def slug
    self.name.gsub(/\s/,'_')
  end

  def self.deslug(name)
    name.gsub(/\_/,' ')
  end

  def events
    e = []
    e += self.all_players.collect{|p| [p.date_joined.to_datetime, "join", p]}
    e += self.retired_players.collect{|p| [p.date_quit.to_datetime, "quit", p]}
    e += self.matches.reject{|m| m.results.nil? or m.results == 0}.collect{|m| [m.scheduled_at.to_datetime, "match", m, self]}
    e
  end


  


end
