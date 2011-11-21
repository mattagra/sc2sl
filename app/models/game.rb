class Game < ActiveRecord::Base

  #Associations
  belongs_to :map
  belongs_to :match
  belongs_to :player0, :class_name => "Player"
  belongs_to :player1, :class_name => "Player"
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Game.to_s}'", :dependent => :destroy

  #Attachments
  has_attached_file :replay, {:url => "/shared/:class/:attachment/:id/:customname.:extension", :path => ":rails_root/public:url"}

  #Rating
  ajaxful_rateable :stars => 5
  
  scope :race0, lambda{ |x| joins(:player0) & Player.race(x)}
  scope :race1, lambda{ |x| joins(:player1) & Player.race(x)}
  
  scope :matchup, lambda{ |x,y| race0(x).race1(y)}

  #Validations
  #None necesary for games. We want to be able to schedule games.

  def self.paginated(page=1,offset=20)
    order('id desc').limit(offset).offset((page - 1) * offset)
  end
  

  def customname
    ("SC2SL " + self.player0.team.short_name + "." + self.player0.user.login + " vs " + self.player1.team.short_name + "."  + self.player1.user.login + " on " + self.map.name).gsub(/\s/,"_")
  end

  def title
     ("SC2SL " + self.player0.team.short_name + "." + self.player0.user.login + " vs " + self.player1.team.short_name + "."  + self.player1.user.login + " on " + self.map.name)
  end

  def scheduled_at
    self.match.scheduled_at
  end

  before_create :set_defaults

  def set_defaults
    self.downloads = 0
  end

  def team0
    self.player0.team if player0
  end

  def team1
    self.player1.team if player1
  end

  def players
    [player0, player1]
  end

  def result_s
    case result
    when 0
      player0.team.short_name
    when 1
      player1.team.short_name
    else
      ""
    end
  end

  def winning_team
    case result
    when 0
      player0.team
    when 1
      player1.team
    else
      nil
    end
  end

  def winning_player
    case result
    when 0
      player0
    when 1
      player1
    else
      nil
    end
  end

  def formatted_spoiler
    ("[spoiler=Winner]" + self.winning_player.to_s + "[/spoiler]").bbcode_to_html(Sc2sl::Application::CUSTOM_BBCODE).bbcode_to_html({}, false, :disable, false)
  end

end
